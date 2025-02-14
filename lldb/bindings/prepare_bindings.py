#!/usr/bin/env python
"""
Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
See https://llvm.org/LICENSE.txt for license information.
SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception

Prepares language bindings for LLDB build process.  Run with --help
to see a description of the supported command line arguments.
"""

# Python modules:
import argparse
import logging
import os
import platform
import sys


def prepare_binding_for_language(bindings_dir, script_lang, options):
    """Prepares the binding for a specific language.

    @param bindings_dir the full path to the bindings source directory.
    @param script_lang the name of the script language.  Should be a child
    directory within the bindings dir, and should contain a
    prepare_bindings_{script_lang}.py script file in it.
    @param options the dictionary of parsed command line options.

    There is no return value.  If it returns, the process succeeded; otherwise,
    the process will exit where it fails.
    """
    # Ensure the language-specific prepare module exists.
    script_name = "prepare_binding_{}.py".format(script_lang)
    lang_path = os.path.join(bindings_dir, script_lang)
    script_path = os.path.join(lang_path, script_name)
    if not os.path.exists(script_path):
        logging.error(
            "failed to find prepare script for language '%s' at '%s'",
            script_lang,
            script_path)
        sys.exit(-9)

    # Include this language-specific directory in the Python search
    # path.
    sys.path.append(os.path.normcase(lang_path))

    # Execute the specific language script
    module_name = os.path.splitext(script_name)[0]
    module = __import__(module_name)
    module.main(options)

    # Remove the language-specific directory from the Python search path.
    sys.path.remove(os.path.normcase(lang_path))


def prepare_all_bindings(options):
    """Prepares bindings for each of the languages supported.

    @param options the parsed arguments from the command line

    @return the exit value for the program. 0 is success, all othes
    indicate some kind of failure.
    """
    # Check for the existence of the SWIG bindings folder
    bindings_dir = os.path.join(options.src_root, "bindings")
    if not os.path.exists(bindings_dir):
        logging.error("failed to find bindings dir: '%s'", bindings_dir)
        sys.exit(-8)

    child_dirs = ["python"]

    # Iterate script directory find any script language directories
    for script_lang in child_dirs:
        logging.info("executing language script for: '%s'", script_lang)
        prepare_binding_for_language(bindings_dir, script_lang, options)


def process_args(args):
    """Returns options processed from the provided command line.

    @param args the command line to process.
    """

    # Setup the parser arguments that are accepted.
    parser = argparse.ArgumentParser(
        description="Prepare language bindings for LLDB build.")

    # Arguments to control logging verbosity.
    parser.add_argument(
        "--debug", "-d",
        action="store_true",
        help="Set program logging level to DEBUG.")
    parser.add_argument(
        "--verbose", "-v",
        action="count",
        default=0,
        help=(
            "Increase logging verbosity level.  Default: only error and "
            "higher are displayed.  Each -v increases level of verbosity."))

    # Arguments to control whether we're building an OS X-style
    # framework.  This is the opposite of the older "-m" (makefile)
    # option.
    parser.add_argument(
        "--config-build-dir",
        "--cfgBldDir",
        help=(
            "Configuration build dir, will use python module path "
            "if unspecified."))
    parser.add_argument(
        "--find-swig",
        action="store_true",
        help=(
            "Indicates the swig executable should be searched for "
            "if not eplicitly provided.  Either this or the explicit "
            "swig executable option must be provided."))
    parser.add_argument(
        "--framework",
        action="store_true",
        help="Prepare as OS X-style framework.")
    parser.add_argument(
        "--generate-dependency-file",
        "-M",
        action="store_true",
        help="Make the dependency (.d) file for the wrappers.")
    parser.add_argument(
        "--prefix",
        help="Override path where the LLDB module is placed.")
    parser.add_argument(
        "--src-root",
        "--srcRoot",
        "-s",
        # Default to the parent directory of this script's directory.
        default=os.path.abspath(
            os.path.join(
                os.path.dirname(os.path.realpath(__file__)),
                os.path.pardir)),
        help="Specifies the LLDB source root directory.")
    parser.add_argument(
        "--build-root",
        "--buildRoot",
        "-b",
        help="Specifies the LLDB build root directory.")
    parser.add_argument(
        "--swig-executable",
        "--swigExecutable",
        help="Path to the swig executable.")
    parser.add_argument(
        "--target-dir",
        "--targetDir",
        required=True,
        help=(
            "Specifies the build dir where the language binding "
            "should be placed"))

    parser.add_argument(
        "--target-platform",
        help=(
            "Specifies the platform we are building for."
            "Should be the same as what platform.system() returns."))

    group = parser.add_argument_group("static binding usage")
    group.add_argument(
        "--use-static-binding",
        action="store_true",
        help=(
            "Specify the pre-baked binding can be used if "
            "swig cannot be found."))
    group.add_argument(
        "--static-binding-dir",
        default="static-binding",
        help="script-relative directory for appropriate static bindings"
    )

    # Process args.
    options = parser.parse_args(args)

    # Set logging level based on verbosity count.
    if options.debug:
        log_level = logging.DEBUG
    else:
        # See logging documentation for error levels.  We'll default
        # to showing ERROR or higher error messages.  For each -v
        # specified, we'll shift to the next lower-priority log level.
        log_level = logging.ERROR - 10 * options.verbose
        if log_level < logging.NOTSET:
            # Displays all logged messages.
            log_level = logging.NOTSET
    logging.basicConfig(level=log_level)
    logging.info("logging is using level: %d", log_level)

    return options


def find_file_in_paths(paths, exe_basename):
    """Returns the full exe path for the first path match.

    @params paths the list of directories to search for the exe_basename
    executable
    @params exe_basename the name of the file for which to search.
    e.g. "swig" or "swig.exe".

    @return the full path to the executable if found in one of the
    given paths; otherwise, returns None.
    """
    for path in paths:
        trial_exe_path = os.path.join(path, exe_basename)
        if os.path.exists(trial_exe_path):
            return os.path.normcase(trial_exe_path)
    return None


def find_swig_executable(options):
    """Finds the swig executable in the PATH or known good locations.

    :param options the command line options returned by argparse.

    Replaces options.swig_executable with the full swig executable path.
    """
    # Figure out what we're looking for.
    if platform.system() == 'Windows':
        exe_basename = "swig.exe"
        extra_dirs = []
    else:
        exe_basename = "swig"
        extra_dirs = ["/usr/local/bin"]

    # Figure out what paths to check.
    path_env = os.environ.get("PATH", None)
    if path_env is not None:
        paths_to_check = path_env.split(os.path.pathsep)
    else:
        paths_to_check = []

    # Add in the extra dirs
    paths_to_check.extend(extra_dirs)
    if len(paths_to_check) < 1:
        logging.info("failed to find swig: no paths available")
        return

    # Find the swig executable
    options.swig_executable = find_file_in_paths(paths_to_check, exe_basename)
    if not options.swig_executable or len(options.swig_executable) < 1:
        logging.info(
            "%s not found in paths %s",
            exe_basename,
            paths_to_check)
    else:
        logging.info("found swig executable: %s", options.swig_executable)


def main(args):
    """Drives the main script preparation steps.

    @param args list of command line arguments.
    """
    # Process command line arguments.
    options = process_args(args)
    logging.debug("Processed args: options=%s", options)

    if options.use_static_binding:
        # Clear the swig executable if we want to use the static bindings.
        options.swig_executable = None
        options.find_swig = False
    elif not options.swig_executable or len(options.swig_executable) == 0:
        # Ensure we have a swig executable.
        if options.find_swig:
            find_swig_executable(options)
        else:
            logging.error(
                "The --find-swig option must be specified "
                "when the swig executable location is not "
                "explicitly provided and not using the "
                "static bindings.")
            sys.exit(-12)

    # Check if the swig file exists.
    swig_path = os.path.normcase(
        os.path.join(options.src_root, "bindings", "python", "python.swig"))
    if not os.path.isfile(swig_path):
        logging.error("swig file not found at '%s'", swig_path)
        sys.exit(-3)

    # Prepare bindings for each supported language binding.
    # This will error out if it doesn't succeed.
    prepare_all_bindings(options)
    sys.exit(0)

if __name__ == "__main__":
    # Run the main driver loop.
    main(sys.argv[1:])
