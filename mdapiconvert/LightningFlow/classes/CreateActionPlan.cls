public class CreateActionPlan {

    @InvocableMethod(label='Create action Plan' description='Create action Plans')
    public static List<String> createActionPlan(List<actionPlanInfo> actionPlans)
    {
        //Add validation that all data is present.
		Action_Plan_Template__c actionPlanTemplate = new Action_Plan_Template__c();
		List<Action_Plan_Template__c> actionPlanTemplates = new List<Action_Plan_Template__c>();
		List<Action_Plan_Problem__c> templateProblems = new List<Action_Plan_Problem__c>();
        List<Action_Plan_Goal__c> templateGoals  = new List<Action_Plan_Goal__c>();

		List<String> templateProblemIds = new List<String>();
        List<String> templateGoalIds = new List<String>();
        ActionPlanInfo actionPlan = new ActionPlanInfo();
        if (!actionPlans.isEmpty()) {
            actionPlan = actionPlans[0];
        }
        system.debug('actionPlan $$ ' + actionPlan);
		
        //Get Template
        if(actionPlan.templateId != null)
        {
            actionPlanTemplates = [select id, Name, description__c from Action_Plan_Template__c where id =:actionPlan.templateId  and active__c = true limit 1];
            if (!actionPlanTemplates.isEmpty())
            {
                actionPlanTemplate = actionPlanTemplates[0];
            }
        }
        system.debug('actionPlanTemplate $$ ' + actionPlanTemplate);
        //Get template Problems, based on problems
        templateProblems = [select id, name, Action_Plan_Template__c, Description__c, Priority__c, Sort_Order__c
                           from Action_Plan_Problem__c where Action_Plan_Template__c = :actionPlanTemplate.id ];
        system.debug('templateProblems $$ ' + templateProblems);
        
        //Loop through and get problemIds
        for (Action_Plan_Problem__c p : templateProblems)
        {
            templateProblemIds.add(p.id);
        }
        system.debug('templateProblemIds ' + templateProblemIds);
        //Get Template goals based on problems
        if (!templateProblemIds.isEmpty())
        {
            templateGoals = [select id, name, Description__c, Priority__c, Action_Plan_Problem__c, Sort_Order__c	
                             from Action_Plan_Goal__c where Action_Plan_Problem__c in :templateProblemIds];
        }
                 
        //Create action plan (Case)
        Case newactionPlan = new Case();
        newactionPlan.contactId = actionPlan.contactId;
        newactionPlan.Subject = actionPlanTemplate.name;
        newactionPlan.Status = 'New';
        newActionPlan.Description = actionPlanTemplate.Description__c;
        newactionPlan.Priority = 'Medium';
        
        insert newactionPlan;
        
        system.debug('newactionPlan $$ ' + newactionPlan);
        //Create action Plan Problems. 
        List<Action_Plan_Problem__c> actionPlanProblems = new List<Action_Plan_Problem__c>();
        for (Action_Plan_Problem__c p : templateProblems)
        {
            Action_Plan_Problem__c newactionPlanProblem = new Action_Plan_Problem__c();
            newActionPlanProblem.Case__c = newactionPlan.id;
           // newActionPlanProblem.Action_Plan_Template__c = actionPlanTemplate.id;
            newActionPlanProblem.ProblemTemplate__c =  p.id;
            newActionPlanProblem.Description__c = p.Description__c;
            newActionPlanProblem.Priority__c = p.Priority__c;
            newActionPlanProblem.Sort_Order__c = p.Sort_Order__c;
            newactionPlanProblem.Name = p.name;
            actionPlanProblems.add(newActionPlanProblem);
        }
        insert actionPlanProblems;
        
        system.debug('actionPlanProblems $$ ' + actionPlanProblems);
        //Create action Plan Goals. 
        List<Action_Plan_Goal__c> actionPlanGoals = new List<Action_Plan_Goal__c>();
        for (Action_Plan_Goal__c  g : templateGoals)
        {
            Action_Plan_Goal__c newactionPlanGoal = new Action_Plan_Goal__c();
            //newactionPlanGoal.Action_Plan_Problem__c = newactionPlan.id;
            for (Action_Plan_Problem__c p : actionPlanProblems)
            {
                if (g.Action_Plan_Problem__c == p.ProblemTemplate__c )
                {
                    newactionPlanGoal.Action_Plan_Problem__c = p.id;
                    newactionPlanGoal.GoalTemplate__c = g.id;
                }
            }
           // newactionPlanGoal.Action_Plan_Problem__c = newactionPlan.id;
           // newactionPlanGoal.HealthCloudGA__actionPlanTemplate__c = actionPlanTemplate.id;
            newactionPlanGoal.Priority__c = g.Priority__c;
            newactionPlanGoal.name = g.name;
            newactionPlanGoal.Description__c = g.Description__c;
            newactionPlanGoal.Sort_Order__c = g.Sort_Order__c;
            actionPlanGoals.add(newactionPlanGoal);
        }
        insert actionPlanGoals;
		system.debug('actionPlanGoals $$ ' + actionPlanGoals);
        
        return new List<String>{newactionPlan.id};
    }
    
    


public class ActionPlanInfo {
		@invocableVariable
        public  String templateId;
  		@invocableVariable
        public  String contactId;
    	@invocableVariable
        public  Integer score;

}
}