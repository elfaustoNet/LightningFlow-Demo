public class CreateActionPlan {

    /* createActionPlan
     * Bulkified for Multiple records
     */
    @InvocableMethod(label='Create Action Plan' description='Create Action Plans')
    public static List<String> createActionPlan(List<actionPlanInfo> actionPlanInfos)
    {
        //Add validation that all data is present.
		Action_Plan_Template__c actionPlanTemplate = new Action_Plan_Template__c();
		List<Action_Plan_Template__c> actionPlanTemplates = new List<Action_Plan_Template__c>();
		List<Action_Plan_Template_Problem__c> templateProblems = new List<Action_Plan_Template_Problem__c>();
        List<Action_Plan_Template_Goal__c> templateGoals  = new List<Action_Plan_Template_Goal__c>();

		List<String> templateProblemIds = new List<String>();
        List<String> templateGoalIds = new List<String>();

        //ActionPlanInfo actionPlan = new ActionPlanInfo();
        /*if (!actionPlans.isEmpty()) {
            actionPlan = actionPlans[0];
        }*/
        List<String> actionPlanTemplateIds = new List<String>();
        for (ActionPlanInfo api : actionPlanInfos)
        {
            actionPlanTemplateIds.add(api.templateId);
        }

        system.debug('actionPlan $$ ' + actionPlanInfos);
		
        //Get Template
        if(!actionPlanTemplateIds.isEmpty())
        {
            actionPlanTemplates = [select id, Name, description__c from Action_Plan_Template__c where id in:actionPlanTemplateIds  and active__c = true limit 500];
        }
        system.debug('actionPlanTemplate $$ ' + actionPlanTemplate);
        //Get template Problems, based on problems
        templateProblems = [select id, name, Action_Plan_Template__c, Description__c, Priority__c, Sort_Order__c
                           from Action_Plan_Template_Problem__c where Action_Plan_Template__c in :actionPlanTemplates ];
        system.debug('templateProblems $$ ' + templateProblems);
        
        //Loop through and get problemIds
        for (Action_Plan_Template_Problem__c p : templateProblems)
        {
            templateProblemIds.add(p.id);
        }
        system.debug('templateProblemIds ' + templateProblemIds);
        //Get Template goals based on problems
        if (!templateProblemIds.isEmpty())
        {
            templateGoals = [select id, name, Description__c, Priority__c, Action_Plan_Template_Problem__c, Sort_Order__c	
                             from Action_Plan_Template_Goal__c where Action_Plan_Template_Problem__c in :templateProblemIds];
        }
        List<Action_Plan__c> actionPlans = new List<Action_Plan__c>();
        for (Action_Plan_Template__c apt : actionPlanTemplates)
        {

        
            for (ActionPlanInfo ap : actionPlanInfos)
            {
                //Create action plan
                if (ap.templateId == apt.id)
                {
                    Action_Plan__c newactionPlan = new Action_Plan__c();
                    newactionPlan.Contact__c = ap.contactId;
                    newactionPlan.Name = apt.name;
                    newactionPlan.Status__c = 'New';
                    newActionPlan.Description__c = apt.Description__c;
                    newActionPlan.Action_Plan_Template__c = apt.id;
                    //Associate action plan to case when case is passed to it
                    newActionPlan.Case__c = ap.caseId;
                    actionPlans.add(newActionPlan);
                    break;
                }

            }
        }
        insert actionPlans;
        
        system.debug('actionPlans $$ ' + actionPlans);
        //Create action Plan Problems. 
        List<Action_Plan_Problem__c> actionPlanProblems = new List<Action_Plan_Problem__c>();
        for (Action_Plan_Template_Problem__c p : templateProblems)
        {       
                for (Action_Plan__c ap : actionPlans)
                {
                    //Need to match on template Id and action plan to create problem
                    system.debug('action plan template $$ ' + p.Action_Plan_Template__c + ' ' + ap.Action_Plan_Template__c);
                    if (p.Action_Plan_Template__c == ap.Action_Plan_Template__c)
                    {
                        Action_Plan_Problem__c newactionPlanProblem = new Action_Plan_Problem__c();
                        newActionPlanProblem.Description__c = p.Description__c;
                        newActionPlanProblem.Priority__c = p.Priority__c;
                        newActionPlanProblem.Sort_Order__c = p.Sort_Order__c;
                        newactionPlanProblem.Name = p.name;
                        newactionPlanProblem.Action_Plan_Template_Problem__c = p.id;
                        newActionPlanProblem.Action_Plan__c = ap.id;
                        actionPlanProblems.add(newActionPlanProblem);
                        break;
                    }
                }
                
        }
        insert actionPlanProblems;
        
        system.debug('actionPlanProblems $$ ' + actionPlanProblems);
        //Create action Plan Goals. 
        List<Action_Plan_Goal__c> actionPlanGoals = new List<Action_Plan_Goal__c>();
        for (Action_Plan_Template_Goal__c  g : templateGoals)
        {
           
            //newactionPlanGoal.Action_Plan_Problem__c = newactionPlan.id;
            for (Action_Plan_Problem__c pp : actionPlanProblems)
            {
                system.debug('action plan problem $$ ' + pp.Action_Plan_Template_Problem__c + ' ' + 
                    pp.Action_Plan_Template_Problem__c);
                if (g.Action_Plan_Template_Problem__c == pp.Action_Plan_Template_Problem__c )
                {
                    Action_Plan_Goal__c newactionPlanGoal = new Action_Plan_Goal__c();
                    newactionPlanGoal.Action_Plan_Problem__c = pp.id;
                    newactionPlanGoal.Priority__c = g.Priority__c;
                    newactionPlanGoal.name = g.name;
                    newactionPlanGoal.Description__c = g.Description__c;
                    newactionPlanGoal.Sort_Order__c = g.Sort_Order__c;
                    newactionPlanGoal.Action_Plan_Template_Goal__c = g.id;
                    actionPlanGoals.add(newactionPlanGoal);
                    break;
                }
            }
            
        }
        insert actionPlanGoals;
		system.debug('actionPlanGoals $$ ' + actionPlanGoals);
        
        List<String> returnIds = new List<String>();
        for (Action_Plan__c ap : actionPlans)
        {
            returnIds.add(ap.id);
        }
        return returnIds;
    }
    
    


public class ActionPlanInfo {
		@invocableVariable
        public  String templateId;
  		@invocableVariable
        public  String contactId;
    	@invocableVariable
        public  String caseId;

}
}