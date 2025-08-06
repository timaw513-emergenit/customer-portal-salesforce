#!/bin/bash

# Customer Portal Salesforce Project Setup Script
# This script sets up a complete development environment

echo "🚀 Starting Customer Portal Salesforce Project Setup..."

# Check if Salesforce CLI is installed
if ! command -v sf &> /dev/null; then
    echo "❌ Salesforce CLI is not installed. Please install it first:"
    echo "   npm install -g @salesforce/cli"
    exit 1
fi

# Check if user is authenticated with a Dev Hub
echo "📋 Checking Dev Hub authentication..."
DEV_HUB_CHECK=$(sf org list --json | jq -r '.result[] | select(.isDevHub==true) | .alias' | head -1)

if [ -z "$DEV_HUB_CHECK" ]; then
    echo "❌ No Dev Hub found. Please authenticate with a Dev Hub first:"
    echo "   sf org login web --set-default-dev-hub"
    exit 1
fi

echo "✅ Dev Hub found: $DEV_HUB_CHECK"

# Set variables
ORG_ALIAS="customer-portal-dev"
DURATION="30"

echo "🏗️  Creating scratch org: $ORG_ALIAS"

# Create scratch org
sf org create scratch \
    --definition-file config/project-scratch-def.json \
    --alias $ORG_ALIAS \
    --duration-days $DURATION \
    --set-default

if [ $? -ne 0 ]; then
    echo "❌ Failed to create scratch org"
    exit 1
fi

echo "✅ Scratch org created successfully"

echo "📦 Deploying metadata to scratch org..."

# Deploy metadata
sf project deploy start \
    --source-dir force-app \
    --target-org $ORG_ALIAS

if [ $? -ne 0 ]; then
    echo "❌ Failed to deploy metadata"
    exit 1
fi

echo "✅ Metadata deployed successfully"

echo "📊 Importing sample data..."

# Import customer data
sf data import tree \
    --files data/customers.json \
    --target-org $ORG_ALIAS

if [ $? -ne 0 ]; then
    echo "❌ Failed to import customer data"
    exit 1
fi

echo "✅ Customer data imported"

# Import support ticket data
sf data import tree \
    --files data/support_tickets.json \
    --target-org $ORG_ALIAS

if [ $? -ne 0 ]; then
    echo "❌ Failed to import support ticket data"
    exit 1
fi

echo "✅ Support ticket data imported"

echo "🔐 Assigning permission sets..."

# Get the current user info
USER_INFO=$(sf org display user --target-org $ORG_ALIAS --json)
USERNAME=$(echo $USER_INFO | jq -r '.result.username')

# Assign permission set
sf org assign permset \
    --name Customer_Portal_Access \
    --target-org $ORG_ALIAS

if [ $? -ne 0 ]; then
    echo "❌ Failed to assign permission set"
    exit 1
fi

echo "✅ Permission set assigned"

echo "🧪 Running Apex tests..."

# Run tests
sf apex run test \
    --target-org $ORG_ALIAS \
    --wait 10 \
    --code-coverage

if [ $? -ne 0 ]; then
    echo "⚠️  Some tests may have failed, but setup continues..."
fi

echo "✅ Tests completed"

echo "🌐 Opening scratch org..."

# Open the org
sf org open --target-org $ORG_ALIAS

echo ""
echo "🎉 Setup completed successfully!"
echo ""
echo "📋 Summary:"
echo "   • Scratch org alias: $ORG_ALIAS"
echo "   • Username: $USERNAME"
echo "   • Duration: $DURATION days"
echo "   • Custom objects: Customer_Portal_User__c, Support_Ticket__c"
echo "   • Lightning Web Components: customerDashboard, orderHistory, supportTickets"
echo "   • Sample data: 10 customers, 15 support tickets"
echo ""
echo "🚀 Next Steps:"
echo "   1. Navigate to Setup → Apps → App Builder"
echo "   2. Create a new Lightning Page"
echo "   3. Add the Customer Portal components"
echo "   4. Activate the page for your community or app"
echo ""
echo "💡 Useful Commands:"
echo "   sf org open --target-org $ORG_ALIAS"
echo "   sf project deploy start --source-dir force-app --target-org $ORG_ALIAS"
echo "   sf apex run test --target-org $ORG_ALIAS"
echo ""
