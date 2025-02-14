import lldb
from lldbsuite.test.decorators import *
import lldbsuite.test.lldbtest as lldbtest
import lldbsuite.test.lldbutil as lldbutil


@skipIfAsan  # rdar://138777205
class TestCase(lldbtest.TestBase):

    def check_is_in_line(self, thread, linenum):
        frame = thread.frames[0]
        line_entry = frame.GetLineEntry()
        self.assertEqual(linenum, line_entry.GetLine())

    @swiftTest
    @skipIf(oslist=["windows", "linux"])
    def test(self):
        """Test conditions for async step-over."""
        self.build()

        source_file = lldb.SBFileSpec("main.swift")
        target, process, thread, bkpt = lldbutil.run_to_source_breakpoint(
            self, "BREAK HERE", source_file
        )

        # Step over should reach every line in the interval [10, 20]
        expected_line_nums = [10, 11, 12, 13, 14, 15]
        # FIXME: for some reason we loop back to the start of the do block after the last statement.
        # rdar://140159600
        expected_line_nums += [8]
        expected_line_nums += [17, 18, 19, 20]
        for expected_line_num in expected_line_nums:
            thread.StepOver()
            stop_reason = thread.GetStopReason()
            self.assertStopReason(stop_reason, lldb.eStopReasonPlanComplete)
            self.check_is_in_line(thread, expected_line_num)
