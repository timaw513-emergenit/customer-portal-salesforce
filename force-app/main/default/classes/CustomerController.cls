public with sharing class CustomerController {
    
    @AuraEnabled(cacheable=true)
    public static List<Customer_Portal_User__c> getActiveCustomers() {
        return [
            SELECT Id, Name, Email__c, Phone__c, Status__c, CreatedDate
            FROM Customer_Portal_User__c 
            WHERE Status__c = 'Active'
            WITH SECURITY_ENFORCED
            ORDER BY CreatedDate DESC
            LIMIT 100
        ];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Support_Ticket__c> getCustomerTickets(Id customerId) {
        return [
            SELECT Id, Name, Subject__c, CreatedDate
            FROM Support_Ticket__c 
            WHERE Portal_User__c = :customerId
            WITH SECURITY_ENFORCED
            ORDER BY CreatedDate DESC
        ];
    }
    
    @AuraEnabled
    public static Support_Ticket__c createSupportTicket(String subject, Id customerId) {
        Support_Ticket__c ticket = new Support_Ticket__c(
            Subject__c = subject,
            Portal_User__c = customerId
        );
        
        try {
            insert ticket;
            return ticket;
        } catch (Exception e) {
            throw new AuraHandledException('Error creating ticket: ' + e.getMessage());
        }
    }
}