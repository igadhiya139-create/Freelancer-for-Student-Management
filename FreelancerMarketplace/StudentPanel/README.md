# StudentPanel Documentation & Structure
This directory contains the ASP.NET Web Forms, code-behind logic, and UI components specifically designed for students on the Freelancer Marketplace platform.

## Session & Authentication Guards
All pages within StudentPanel/ enforce strict session checks upon Page_Load:
- Verifies Session["Email"] is not null.
- Validates Session["Role"] == "Student".
- Automatically redirects unauthenticated requests to ~/Login.aspx.
