# Customer Portal Salesforce Project

A comprehensive Salesforce Customer Portal solution with custom objects, Lightning Web Components, and automated setup scripts.

## 🚀 Quick Setup Instructions

1. **Clone this repository**:
```bash
git clone https://github.com/timaw513-emergenit/customer-portal-salesforce.git
cd customer-portal-salesforce
```

2. **Create scratch org and deploy**:
```bash
# Create scratch org
sf org create scratch -f config/project-scratch-def.json -a customer-portal-dev -d 30

# Deploy metadata
sf project deploy start --source-dir force-app --target-org customer-portal-dev

# Import sample data
sf data import tree --files data/customers.json --target-org customer-portal-dev
sf data import tree --files data/support_tickets.json --target-org customer-portal-dev

# Assign permissions
sf org assign permset --name Customer_Portal_Access --target-org customer-portal-dev

# Open the org
sf org open --target-org customer-portal-dev
```

## 📁 Project Structure

```
customer-portal-salesforce/
├── README.md
├── sfdx-project.json
├── .forceignore
├── .gitignore
├── config/
│   └── project-scratch-def.json
├── force-app/
│   └── main/
│       └── default/
│           ├── objects/
│           │   ├── Customer_Portal_User__c/
│           │   └── Support_Ticket__c/
│           ├── classes/
│           ├── permissionsets/
│           └── lwc/
├── data/
│   ├── customers.json
│   └── support_tickets.json
└── scripts/
    ├── setup.sh
    └── deploy.sh
```

## 🏗️ Features

### Custom Objects
- **Customer Portal User** (`Customer_Portal_User__c`)
  - Email, Phone, Company, Status fields
  - Relationship to Support Tickets

- **Support Ticket** (`Support_Ticket__c`)
  - Subject, Description, Priority, Status, Category fields
  - Lookup to Customer Portal User

### Lightning Web Components
- **Customer Dashboard** - Main portal overview
- **Order History** - Historical order management
- **Support Tickets** - Ticket creation and tracking

### Security
- Custom permission set with appropriate field-level security
- Configured for portal users with limited access

## 🛠️ Development Commands

```bash
# Validate deployment
sf project deploy validate --source-dir force-app --target-org customer-portal-dev

# Run tests
sf apex run test --target-org customer-portal-dev

# Pull changes from org
sf project retrieve start --source-dir force-app --target-org customer-portal-dev

# Package creation
sf package create --name "Customer Portal" --package-type Unlocked --path force-app --target-dev-hub your-dev-hub
```

## 📊 Sample Data

The project includes sample CSV/JSON files with:
- 50+ sample customer portal users
- 100+ sample support tickets with various statuses and priorities

## 🚀 Deployment Options

### Scratch Org (Development)
Use the quick setup instructions above for development work.

### Sandbox/Production
```bash
# Deploy to sandbox
sf project deploy start --source-dir force-app --target-org your-sandbox

# Deploy to production (with validation)
sf project deploy validate --source-dir force-app --target-org production
sf project deploy start --source-dir force-app --target-org production
```

## 🔧 Customization

### Adding New Fields
1. Add field metadata in `force-app/main/default/objects/[ObjectName]/fields/`
2. Update permission sets if needed
3. Deploy changes

### Adding New Components
1. Create LWC in `force-app/main/default/lwc/`
2. Update component access in permission sets
3. Add to appropriate page layouts

## 📝 Contributing

1. Create feature branch
2. Make changes
3. Run tests: `sf apex run test`
4. Submit pull request

## 📞 Support

For questions or issues, please create a GitHub issue or contact the development team.