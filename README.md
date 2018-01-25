# Lightning Flow Demo

The is an example of leveraging Lightning Flow. The code demonstrates the use of subflows, branching logic to ask additional questions based on selected answers, selecting of a template record based on a total score, and using apex to create an action plan based on template objects.

## Post Install Step
After pushing this code to your org, ensure that all flows are active and that the permission set is assigned to the user. If these items are not complete, the flow will not run properly,


## Sample Demo Script 
#### Overview:
You work in a call center for a health care company. There is a Flow embedded on the contact record using the Flow component.  Based on callers answers you navigate through the flow which helps guide you through the interaction. Notice how the call scripting can pull and display information.

#### Scenario 1: 
Maybe the caller needs to submit a claim for reimbursement.  The flow can pull in existing information you have about the caller which can be used to validate the caller information and if not, you can update the data as you work through the claim process. Then you collect the invoice number and amount. Upon finishing this part of the flow, a case is created with the required information to get the claim processed. The claim number is displayed and then relayed back to the caller. 

#### Scenario 2: 
Maybe the caller's employer has a wellness program. They are calling in to take the accessment and get paired up with a health coach that can help them work through an action plan. As the call center employee, you ask them the questions to the asessment. Then based on the score, a pre-defined action plan is created for the caller. 

#### Flow Walkthrough: 
The Contact Interaction flow is the main for that is embedded on the contact record. Based on the caller's initial reason for calling in, we direct the user to different subflows. Subflows create modularity and reusability. The first step in this flow is querying all the contact record information needed for the flows based on the contactId passed in from the Lightning App Page.  The Health Assessment flow collects the answers, totals the score, and then based on the total, determined which action plan template should be assigned to the caller. The flow then queries the template and passes the id into the Invocable Apex. Leveraging Apex in this scenario allows for more complex business logic (like creating records from templates) and provides a way to reuse so that if they want to set up more templates, an admin doesn't have to recreate the logic. 


## Resource
Salesforce documentation related to the components leveraged in this demo.

[Visual Workflow Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.salesforce_vpm_guide.meta/salesforce_vpm_guide/vpm_intro.htm)
[InvocableMethod Annotation](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_classes_annotation_InvocableMethod.htm)
[InvocableVariable Annotation](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_classes_annotation_InvocableVariable.htmg)