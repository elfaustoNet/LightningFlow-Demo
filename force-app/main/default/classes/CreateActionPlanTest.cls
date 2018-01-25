@isTest
public class CreateActionPlanTest {
    

    static testmethod void test1() {
        CreateActionPlanTestData.intialize();
        Test.startTest();
        List<Action_Plan_Template__c> templates = [select id, Name From Action_Plan_Template__c Where name = 'High Risk Plan' limit 1];
        List<Contact> theContact = [select id, name from Contact limit 1];
        List<Case> theCase = [select id from Case limit 1];
        List<CreateActionPlan.ActionPlanInfo> infos = new List<CreateActionPlan.ActionPlanInfo>();
        CreateActionPlan.ActionPlanInfo newAPI = new CreateActionPlan.ActionPlanInfo();
        newAPI.contactId = theContact[0].id;
        newAPI.templateId = templates[0].id;
        newAPI.caseId = theCase[0].id;
        infos.add(newAPI);
        CreateActionPlan.createActionPlan(new List<CreateActionPlan.ActionPlanInfo>{newAPI});
        List<Action_Plan__c> actionPlans = new List<Action_Plan__c>();
        actionPlans = [select id, Name from Action_Plan__c where Contact__c = :theContact[0].id ];
        system.assertEquals(actionPlans.size(), 1);
        Test.stopTest();
    }
}
