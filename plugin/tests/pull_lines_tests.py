import unittest
import pull_lines as sut


@unittest.skip("Don't forget to test!")
class PullLinesTests(unittest.TestCase):

    def test_example_fail(self):
        result = sut.pull_lines_example()
        self.assertEqual("Happy Hacking", result)
