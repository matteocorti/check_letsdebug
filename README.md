
 &copy; Matteo Corti, 2021-2024
  see AUTHORS for the complete list of contributors

# check\_letsdebug

Nagjos plugin to check the status of a domain by Let's Encrypt

## Usage

```

Usage: check_letsdebug -d domain [OPTIONS]

Arguments:
   -D,--domain domain              domain

Options:
   -d,--debug                      produces debugging output (can be specified more than once)
      --debug-file file            writes the debug messages to file
      --id id                      retrieves the result of a previous test
   -h,--help,-?                    this help message
      --proxy proxy                sets http_proxy and the s_client -proxy option
      --temp dir                   directory where to store the temporary files
   -t,--timeout                    seconds timeout after the specified time
                                   (defaults to 120 seconds)
   -v,--verbose                    verbose output (can be specified more than once)
   -V,--version                    version
   -4                              force IPv4
   -6                              force IPv6


Report bugs to https://github.com/matteocorti/check_letsdebug/issues
```

## Required Software

To run the script

 * cURL

To build a release you additionally need

 * bzip2
 * make

And to check the code

  * [ShellCheck](https://www.shellcheck.net)

## Bugs

The timeout is applied to each action involving a download.

Report bugs to [https://github.com/matteocorti/check_letsdebug/issues](https://github.com/matteocorti/check_letsdebug/issues)
