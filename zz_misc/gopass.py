#!/usr/bin/python

# COMMANDS:
#      agent               Start gopass-agent
#      audit               Scan for weak passwords
#      binary, bin         Assist with Binary/Base64 content
#...

##compdef cmd
# local -a subcmds
# subcmds=('c:description for c command' 'd:description for d command')
# _describe 'command' subcmds
# (-p --paginate --no-pager)'{-p,--paginate}'[pipe all output into ''less'']


# GLOBAL OPTIONS:
#    --yes          Assume yes on all yes/no questions or use the default on all others
#    --clip, -c     Copy the first line of the secret into the clipboard
#    --help, -h     show help
#    --version, -v  print the version
#    --store value, -s value  Select the store to sync

# _arguments -OPT[DESCRIPTION]:MESSAGE:ACTION
# _arguments '-s[sort output]' '1:first arg:_net_interfaces' '::optional arg:_files' ':next arg:(a b c)'

import subprocess, re, sys
import pprint

commands = {}
options = {}

def parse_output(commands, context):
    output = subprocess.Popen('{} --help'.format(context),
                              stdout=subprocess.PIPE,
                              stderr=subprocess.PIPE,
                              shell=True)
    in_commands = False
    in_opts = False
    commands[context] = []

    for line in output.stdout:
        line = line.rstrip()

        # Section handling
        if re.search(r'^COMMANDS:$', line):
            in_commands = True
            in_opts = False
            continue
        elif re.search(r'^OPTIONS:$', line):
            in_commands = False
            in_opts = True
            continue
        elif (in_commands or in_opts) and re.search(r'^\s*$', line):
            in_commands = False
            in_opts = False
            continue

        # Parse commands
        if in_commands:
            parse_cmd(commands, context, line)
        # Parse options
        if in_opts:
            parse_opt(commands, context, line)

    return [commands, options]

def parse_cmd(commands, context, line):
    options = []

    [cmdstr, desc] = re.match(r'^     (\S+(?:, \S+)*)(?:  +(\b.*))?$', line).groups()
    cmds = re.split(r', ', cmdstr)
    if len(cmds) > 1:
        commands[context].append('({}){{{}}}[{}]'.format(
            ' '.join(cmds), ','.join(cmds), desc
        ))
    else:
        commands[context].append('{}[{}]'.format(cmds[0], desc))

    # parse and append subcommands and subopts
    subcontext = '{} {}'.format(context, cmds[0])
    parse_output(commands, subcontext)

def parse_opt(commands, context, line):
    options = []

    print(line)
    [optstr, desc] = re.match(r'^   (\S+(?: \S+)*)(?:  +(\S.*))?$', line).groups()
    if desc == None:
        desc = ''
    opts = re.split(r', ', optstr)
    if len(opts) > 1:
        for opt in opts:
            [name, value] = re.split(r' ', opt)
        options.append('({}){{{}}}[{}]'.format(
            ' '.join(opts), ','.join(opts), desc
        ))
    else:
        commands[context].append('{}[{}]'.format(opts[0], desc))

pprint.pprint(parse_output({}, "gopass"))
