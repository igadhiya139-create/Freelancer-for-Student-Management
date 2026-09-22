This folder stores uploaded profile images from the Registration form.

IIS / IIS Express app pool identity must have WRITE permission to this folder.

To grant permissions (run as Administrator in PowerShell):
  icacls "D:\New folder\FreelancerMarketplace\images" /grant "IIS_IUSRS:(OI)(CI)F"
