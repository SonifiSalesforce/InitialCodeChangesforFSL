/*
jjackson Sonifi Solutions 4/2019:  Field Service Lightning Project, also converting the installation group
to the lightning platform so this code with visualforce page will be a new button/lightning action to replace
a javascript button in classic.  TODO:  Create the visualforce page needed for the button.
*/

public with sharing class CustomButtonSubmitforCompletion {
	
	public WorkOrder wo {get;set;}
	public WorkOrder worec;
	public Id woid;
	public List<WorkOrder> lstwo = New List<WorkOrder>();
	
	
	public CustomButtonSubmitforCompletion(ApexPages.StandardController controller)
    {
  		wo = (WorkOrder)controller.getRecord();
		lstwo = [ Select recordtypeid, id, billing_approval_needed__c, approver__c, install_complete_date__c,
		          De_Installation_Date__c from WorkOrder where id = :wo.id ];
		          
		worec = lstwo[0];
    }
    
    public String errormessage()
    {
    	String message = '';
    	String rectypename = Utilities.RecordTypeIdtoName(worec.recordtypeid, 'WorkOrder');
    	
    	if(rectypename == 'De-Install'  && worec.De_Installation_Date__c == null)
           	 { message = 'De-Installation Date is required.';  }
        else if(rectypename == 'Install' && worec.Install_Complete_Date__c == null)
           	 { message = 'Install Complete Date is required.';  }
           	 
        if(worec.Approver__c == null)
        {  message = 'The Approver field cannot be blank.';  }
        
        return message;
 	
    }
    
    public pageReference SubmitforCompletion()
    {
    	
    	String errormsg = errormessage();
    	if(errormsg != '' || errormsg != null)
    	{ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
      				                    'Error in Submit For Completion:  ' +errormsg)); 
         return null;
    	}
    	else
    	{
    	
     	
    			Id uid = UserInfo.getUserId();
    		
    			Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            	req1.setComments('Submitting Work Order for Completion.');
            	req1.setObjectId(worec.id);
            	Approval.ProcessResult result = Approval.process(req1);
              	if(uid == worec.approver__c)
            	{
                	List<Id> newWorkItemIds = result.getNewWorkitemIds();
 	
                	Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
               		req2.setComments('Submitter is Approver, Auto approving');
                	req2.setAction('Approve');
                	req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
                
                	// Use the ID from the newly created item to specify the item to be worked
                	req2.setWorkitemId(newWorkItemIds.get(0));
                
                	// Submit the request for approval
                	Approval.ProcessResult result2 =  Approval.process(req2);
                	system.debug('Autoapproving result:'+result2.isSuccess());
            	}
            	
        	}//end else
        	
        	return null;
 
    	}//end pageref

 
}