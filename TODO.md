# TODO: Fix Leave Repository Errors

## Step 1: Add API Endpoints ✅
- Add `leaveApprove` and `leaveHistory` endpoints to `lib/config/api_endpoints.dart`.

## Step 2: Update LeaveRemote ✅
- Change `submitLeave` in `lib/data/datasources/remote/leave_remote.dart` to return `LeaveModel` instead of `bool`.
- Add `approveLeave` method to `leave_remote.dart`.
- Add `getLeaveHistory` method to `leave_remote.dart`.

## Step 3: Verify Changes ✅
- Ensure all methods match the repository interface.
- Check for any compilation errors.
