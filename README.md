# Lightning Flow Demo

The is an example of leveraging Lightning Flow. The code demonstrates the use of subflows, branching logic to ask additional questions based on selected answers, selecting of a template record based on a total score, and using apex to create an action plan based on template objects.

## Post Install Step
After pushing the code to your org, ensure that all flows are active and Lightning App Pages are activated and assigned. 

Then you will need to assign the permission set to the user.<br>
To do this, run the following command: <br>
>sfdx force:user:permset:assign -n LightningFlowDemo -u \<TARGETUSERNAME\>

Next, import the sample Contact and Action Plan Templates. <br>
To do this, run the following commands:<br>
>sfdx force:data:tree:import -f ./data/Contact.json -u \<TARGETUSERNAME\> <br>
>sfdx force:data:tree:import -p ./data/ActionPlanTemplates-plan.json -u \<TARGETUSERNAME\>

If these steps are not complete, the flow will not run properly,


## Sample Demo Script 
#### Overview:
You work in a call center for a health care company. There is a Flow embedded on the contact record using the Flow component.  Based on callers answers, you navigate through the flow which helps guide you through the interaction. Notice how the call scripting can pull and display information about who you are talking with.

#### Scenario 1: 
Maybe the caller needs to submit a claim for reimbursement.  The flow can pull in existing information you have about the caller which can be used to validate the caller information. If changes are required, you can update the data as you work through the claim process. After you validate the caller info, you collect the invoice number and amount. Upon finishing this part of the flow, a case is created with the required information to get the claim processed. The claim number is displayed and you relay it back to the caller. 

#### Scenario 2: 
Maybe the caller was asked to take a survey for a chance to win a gift card. As you help them through survey, if they answer "Yes" to the question  "How you filed a Claim With Us Before?", they are asked some additional questions that they wouldn't have been asked if they had never filed a claim. 

#### Scenario 3: 
Maybe the caller's employer has a wellness program. They are calling in to take the assessment and get paired up with a health coach that can help them work through an action plan. As the call center employee, you ask them the questions to the asessment. Then based on the score, a pre-defined action plan is created for the caller. 

#### Flow Designer Walkthrough: 
First talk about the pallette and the elements that can be dragged on the canvas to be used. As an amdmin, there are elements to display and collect data, look up records, create records, assign variables, decision logic and call apex.

The Contact Interaction flow is the main for that is embedded on the contact record. Based on the caller's initial reason for calling in, we direct the user to different subflows. Subflows create modularity and reusability. The first step in this flow is querying all the contact record information needed for the flows based on the contactId passed in from the Lightning App Page.  The Health Assessment flow collects the answers, totals the score, and then based on the total, determined which action plan template should be assigned to the caller. The flow then queries the template and passes the id into the Invocable Apex. Leveraging Apex in this scenario allows for more complex business logic (like creating records from templates) and provides a way to reuse so that if they want to set up more templates, an admin doesn't have to recreate the logic. 


## Resources
Salesforce documentation related to the components leveraged in this demo.

[Visual Workflow Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.salesforce_vpm_guide.meta/salesforce_vpm_guide/vpm_intro.htm)

[InvocableMethod Annotation](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_classes_annotation_InvocableMethod.htm)

[InvocableVariable Annotation](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_classes_annotation_InvocableVariable.htmg)