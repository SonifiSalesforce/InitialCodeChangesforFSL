@isTest
public class AssociatedItemTriggerLogicTest
{
    static testMethod void workOrderNameUpdateTest()
    {
    	System.debug(LoggingLevel.DEBUG,'AssociatedItemTriggerLogicTest workOrderNameUpdateTest Test .  **********    START');
    	Account acc = DataGenerator.createAccounts(1, true).get(0);
        List<Product2> pList = DataGenerator.createProducts(9,true);
        pList[0].Name = 'FTG Product Parent';
        pList[0].Family = 'FTG';
        pList[1].Name = 'Interactive Product Parent';
        plist[1].ProductCode = 'CC-test-12345';
		pList[1].Family = 'Interactive';
        pList[2].Name = 'Broadband Product Parent';
		pList[2].Family = 'Broadband';
        pList[3].Name = 'DRE Product Parent';
		pList[3].Family = 'DRE';
        pList[4].Name = 'Professional Solutions Product Parent';
		pList[4].Family = 'Professional Solutions';
        pList[5].Name = 'Public Viewing Product Parent';
		pList[5].Family = 'PV';
        pList[6].Name = 'Direct Sale Product Parent';
		pList[6].Family = 'Direct Sale';
		pList[7].Name = 'SONIFI Select Product Parent';
		pList[7].Family = 'SONIFI Select';
		pList[8].Name = 'SoniCast Product Parent';
		pList[8].Family = 'SoniCast';					
        update pList;
        
        //Create a contract with install clock start dates set for today
	    Contract con = new Contract();
	    con.Accountid = acc.id;
	    con.contract_Status__c = 'Order Approved';
	    con.Interactive_Clock_Start_Date__c = System.Today();
	    insert con;
	    
	    //Add a product parent contract line item to the contract
	    //Contract_Line_Item__c lcli = new Contract_Line_Item__c();
	    SBQQ__Subscription__c lcli = New SBQQ__Subscription__c();
	    lcli.sbqq__contract__c = con.id;
	    lcli.SBQQ__Product__c = pList[1].id;
	    lcli.Name__c = 'Interactive Product Parent';
	    lcli.Project_Type__c = 'Interactive New Rooms';
	    lcli.sbqq__quantity__c = 100;
	    lcli.equipment_ownership__c = 'CUST';
	    insert lcli;
	
	    //Create an order related to the contract and an order item related to the contract line item
	    Order__c o = new Order__c();
	    o.Name = 'Test Account Order';
	    //o.Legal_Contract__c = con.id;
	    o.Site__c = acc.id;
	    insert o;
        
                
        Order_Item__c oi1 = new Order_Item__c(Product__c = pList[0].Id, Order__c = o.id, Status__c = 'Pending Installation Activate',
                                              Name = 'FTG Product Parent');
        Order_Item__c oi2 = new Order_Item__c(Product__c = pList[1].Id, Name = 'Interactive Product Parent',
        subscription__c = lcli.id, Order__c = o.id, Status__c = 'Pending Installation Activate');
        Order_Item__c oi3 = new Order_Item__c(Product__c = pList[2].Id, Order__c = o.id, Name = 'Broadband Product Parent');
        Order_Item__c oi4 = new Order_Item__c(Product__c = pList[3].Id, Order__c = o.id, Name = 'DRE Product Parent');
        Order_Item__c oi5 = new Order_Item__c(Product__c = pList[4].Id, Order__c = o.id, Name = 'Professional Solutions Product Parent');
        Order_Item__c oi6 = new Order_Item__c(Product__c = pList[5].Id, Order__c = o.id, Name = 'Public Viewing Product Parent');
        Order_Item__c oi7 = new Order_Item__c(Product__c = pList[6].Id, Order__c = o.id, Name = 'Direct Sale Product Parent');
        Order_Item__c oi8 = new Order_Item__c(Product__c = pList[7].Id, Order__c = o.id, Name = 'SONIFI Select Product Parent');
        Order_Item__c oi9 = new Order_Item__c(Product__c = pList[8].Id, Order__c = o.id, Name = 'SoniCast Product Parent');
                
        List<Order_Item__c> lstoi = new List<Order_Item__c>();
        lstoi.add(oi1);
        lstoi.add(oi2);
        lstoi.add(oi3);
        lstoi.add(oi4);
        lstoi.add(oi5);
        lstoi.add(oi6);
        lstoi.add(oi7);
        lstoi.add(oi9);
        lstoi.add(oi8);
        
        
        insert lstoi;
        
        RecordType rectypeid = [ Select Id, sobjecttype from RecordType where Name = 'Install' and sobjecttype = 'WorkOrder'  LIMIT 1];
        User userid = [ Select Id from User where Profile.Name = 'System Administrator' LIMIT 1];
        
        WorkOrder wo = new WorkOrder(Accountid = acc.Id, recordtypeid = rectypeid.Id, install_manager__c = userid.id, approver__c = userid.id,
                                             project_coordinator__c = userid.id, Division__c = 'Domestic');
        insert wo;


        Test.startTest();
        
        WorkOrder wonew = [ Select Id, Work_Order_Name__c from WorkOrder LIMIT 1 ];
        RecordType childrectype = [Select Id, sobjecttype from RecordType where name = 'Rack Build' and sobjecttype = 'WorkOrder' LIMIT 1];
        
        system.assert(wonew.work_order_name__c.Contains('Install'));
 
        List<Associated_Item__c> lstai = new List<Associated_Item__c>();
        Associated_Item__c aitem1 = new Associated_Item__c(WorkOrder__c = wo.Id, Order_Item__c = oi1.Id, Status__c = 'Pending Installation Activate', Name = 'FTG Product Parent');
        lstai.add(aitem1);
        Associated_Item__c aitem2 = new Associated_Item__c(WorkOrder__c = wo.Id, Order_Item__c = oi2.Id, Status__c = 'Pending Installation Activate', Name = 'Interactive Product Parent');
        lstai.add(aitem2);
        Associated_Item__c aitem3 = new Associated_Item__c(WorkOrder__c = wo.Id, Order_Item__c = oi3.Id, Name = 'Broadband Product Parent');
        lstai.add(aitem3);
        Associated_Item__c aitem4 = new Associated_Item__c(WorkOrder__c = wo.Id, Order_Item__c = oi4.Id, Name = 'DRE Product Parent');
        lstai.add(aitem4);
        Associated_Item__c aitem5 = new Associated_Item__c(WorkOrder__c = wo.Id, Order_Item__c = oi5.Id, Name = 'Professional Solutions Product Parent');
        lstai.add(aitem5);
        Associated_Item__c aitem6 = new Associated_Item__c(WorkOrder__c = wo.Id, Order_Item__c = oi6.Id, Status__c = 'Pending Installation Activate', Name = 'Public Viewing Product Parent');
        lstai.add(aitem6);
        Associated_Item__c aitem7 = new Associated_Item__c(WorkOrder__c = wo.Id, Order_Item__c = oi7.Id, Name = 'Direct Sale Product Parent');
        lstai.add(aitem7);
        Associated_Item__c aitem8 = new Associated_Item__c(WorkOrder__c = wo.Id, Order_Item__c = oi8.Id, Name = 'SONIFI Select Product Parent');
        lstai.add(aitem8);
        Associated_Item__c aitem9 = new Associated_Item__c(WorkOrder__c = wo.Id, Order_Item__c = oi9.Id, Name = 'SoniCast Product Parent');
        lstai.add(aitem9);
        
  		insert lstai;
  		
  		//RecordType rectypeidchild = [ Select Id from RecordType where Name = 'Rack Build' LIMIT 1];
  		WorkOrder childrackwo = New WorkOrder(Accountid = acc.id, work_order_name__c = 'Test Child', Recordtypeid = childrectype.id, parentworkorderid = wo.id);
  		insert childrackwo;
  		
  		List<Associated_Item__c> updatestatuslist = New List<Associated_Item__c>();
  		List<Associated_Item__c> updateai = New List<Associated_Item__c>();
  		updatestatuslist = [ Select Id, Name, status__c from Associated_Item__c where status__c = 'Pending Installation Activate'];
  		for(Associated_Item__c ai : updatestatuslist)
  		{
  			ai.status__c = 'Billing';  //this tests UpdateOrderItemStatus method
  			updateai.add(ai);
  		}
  		
  		update updateai;
  		
		
		
  
        
        List<WorkOrder> woupdlist = [SELECT work_order_name__c, parentworkorderid from workorder ];
        for(WorkOrder worec : woupdlist)
        { 
        	if(worec.parentworkorderid == null)
        	{   system.debug('test parent work order name is ' +worec.work_order_name__c);
        		system.assert(worec.work_order_name__c.Contains('Interactive-FTG-DRE-GIA-')); 
        	   
        	}
        }
        
        List<Order_Item__c> updatedoilist = New List<Order_Item__c>();
        updatedoilist = [ Select Id, Name, status__c from Order_Item__c where Name in ('FTG Product Parent', 'Interactive Product Parent', 'Public Viewing Product Parent')];
        for(Order_Item__c updoi : updatedoilist)
        {
        	system.assert(updoi.status__c == 'Billing');
        }
        
        
        //now delete one of the product parent associated items to test RemoveProductParent method
        delete aitem1;
        
        Test.stopTest();
        
        List<WorkOrder> delwolist = [ Select Id, work_order_name__c from WorkOrder ];
        for(WorkOrder delwo : delwolist)
        { // system.assert(!delwo.Name.Contains('FTG'));  
        	system.debug('after deletion work order name is ' +delwo.work_order_name__c);
        }
        
 
        //System.debug(LoggingLevel.DEBUG,'AssociatedItemTriggerLogicTest workOrderNameUpdateTest Test .  **********    FinsihedT');
    }
    
    static testMethod void testWorkOrderItemEmailNotification()
    {
    	WorkOrderStatusNotification__c cs = new WorkOrderStatusNotification__c(Name = 'Install', Status_Values__c = 'Schedule Work Order');
    	insert cs;
		Account a = new Account(Name = 'Test Account');
		insert a;
		//Create work order with reocrd type install and in status schedule work order
		Id woRecordType = Utilities.RecordTypeNameToId('WorkOrder','Install');
		WorkOrder wo = new WorkOrder(Accountid = a.Id, RecordTypeId =woRecordType, Status = 'Schedule Work Order');
		insert wo;
	    //Get Email limit before
	    Integer emailbefore = Limits.getEmailInvocations();
        Order_Item__c oi1 = new Order_Item__c(Status__c = 'Pending Installation Activate');
        insert oi1;
		
		Associated_Item__c ai1 = new Associated_Item__c(WorkOrder__c = wo.Id, Order_Item__c = oi1.Id, Status__c = 'Pending Installation Activate');
        insert ai1;
		
		Test.startTest();
        ai1.Status__c = 'Cancelled';
		update ai1;
		
		Order_Item__c recorditm = [Select ID,Status__c from Order_Item__c where ID = :oi1.Id LIMIT 1];
		system.assert(recorditm.Status__c == 'Cancelled');
		system.debug('order item status in test is ' +recorditm.Status__c);
		
		delete ai1;
		Test.stopTest();
		
    }
    
 
 }