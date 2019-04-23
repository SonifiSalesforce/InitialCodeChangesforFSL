# InitialCodeChangesforFSL
Store code changes to accommodate the FSL project when the original solution 
design was to replace work_order__c object with workorder object.

This repository just saves code that was changed for the FSL project.
The original solution design was to replace the use of the work_order__c
object with the standard salesforce WorkOrder object, then repoint the associated_item__c
object to WorkOrder.  We went down that path with updating code to use the WorkOrder
object.  Then that solution design was abandoned in favor of retaining the custom
work_order__c object, so we have to revert the code in the stg sandbox back to the
original.  This repository saves the original code changes we made so in case there
is another change in the solution design, we will have these code changes to use
or refer to if need be.
--jjackson Sonifi Solutions 4/23/2019
