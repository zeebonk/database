# Asyncy App

## Organizations
- Has N Applications
- Has N Owners
- Has 1 Billing Account
- Has N paid service subscriptions

## Owners
- Has 1 GitHub Username (an organization or user account).
- Has N Repos

## Repositories
- Has 1 GitHub Repository
- Has N Builds

## Applications
- Has 1 GKE property (billing)
- Has N Teams (privileges)
- Has N Releases
- Has N DNS Entries
- Has 1 generated domain at $.asyncyapp.com

## Teams
- Has 1 GitHub Team
- Has 1 GitHub Owner
- Has N Owners(type=user) as members
- Has N privileges
