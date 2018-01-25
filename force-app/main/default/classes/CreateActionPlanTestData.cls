public class CreateActionPlanTestData {
    
    public static void intialize() {
        Account newAccount = createAccount();
        insert newAccount;
        Contact newContact = createContact(newAccount.id);
        insert newContact;
        Case newCase = createCase(newAccount.Id, newContact.Id);
        insert newCase;
        List<Action_Plan_Template__c> actionPlanTemplates = createActionPlanTemplates(new List<String>{'High Risk Plan', 'Medium Risk Plan'});
        insert actionPlanTemplates;
        List<Action_Plan_Template_Problem__c> actionPlanTemplateProblems = createActionPlanTemplateProblems(actionPlanTemplates, 2);
        insert actionPlanTemplateProblems;
        List<Action_Plan_Template_Goal__c> actionPlanTemplateGoals = createActionPlanTemplateGoals(actionPlanTemplateProblems, 2);
        insert actionPlanTemplateGoals;

    }

    public static Account createAccount() {
        Account a1 = new Account();
        a1.Name = 'Test Account';
        return a1;
    }
    public static Contact createContact(String accountId) {
        Contact newContact = new Contact();
        newContact.FirstName = 'Bill';
        newContact.LastName = 'TestUser';
        newContact.Phone = '555-555-5555';
        newContact.Email = 'test@example.com';
        newContact.AccountId = accountId;
        return newContact;

    }
    public static Case createCase(String accountId, String contactId) {
        Case newCase = new Case();
        newCase.Subject = 'Case for ' + contactId;
        newCase.Priority = 'Medium';
        newCase.AccountId = accountId;
        newCase.contactId = contactId;
        return newCase;
    }
    public static List<Action_Plan_Template__c> createActionPlanTemplates(List<String> templateNames)
    {
        List<Action_Plan_Template__c> actionPlanTemplates = new List<Action_Plan_Template__c>();
        for (String s : templateNames) {
            Action_Plan_Template__c ap = new Action_Plan_Template__c();
            ap.Name = s;
            ap.Active__c = true;
            ap.Description__c = s + ' test description';
            actionPlanTemplates.add(ap);
        }
        return actionPlanTemplates;
    }

    public static  List<Action_Plan_Template_Problem__c> createActionPlanTemplateProblems(List<Action_Plan_Template__c> templates, Integer cnt)
    {
        List<Action_Plan_Template_Problem__c> actionPlanTemplateProblems = new List<Action_Plan_Template_Problem__c>();
        for (Action_Plan_Template__c apt : templates) {
            for (integer i = 1; i <= cnt; i++)
            {
                Action_Plan_Template_Problem__c aptp = new Action_Plan_Template_Problem__c();
                aptp.Name = 'Test Problem' + String.valueOf(i);
                aptp.Priority__c = 'Medium';
                aptp.Sort_Order__c = i;
                aptp.Action_Plan_Template__c = apt.id;
                actionPlanTemplateProblems.add(aptp);
            }
        }
        return actionPlanTemplateProblems;
    }
    public static List<Action_Plan_template_Goal__c> createActionPlanTemplateGoals(List<Action_Plan_Template_Problem__c> problems, Integer cnt)  {
        List<Action_Plan_Template_Goal__c> actionPlanTemplateGoals = new List<Action_Plan_template_Goal__c>();
        for (Action_Plan_Template_Problem__c aptp : problems) {
            for (integer i=1; i <= cnt; i++) {
                Action_Plan_Template_Goal__c aptg = new Action_Plan_Template_Goal__c();
                aptg.Name = 'Test Goal' + String.valueOf(i);
                aptg.Description__c = 'Description Goal' + String.valueOf(i);
                aptg.Sort_Order__c = i;
                aptg.Priority__c = 'Medium';
                aptg.Action_Plan_Template_Problem__c = aptp.id;
                actionPlanTemplateGoals.add(aptg);
            }
        }
        return actionPlanTemplateGoals;
    }
}
