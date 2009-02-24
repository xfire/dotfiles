#!/usr/bin/env python
#
# vim:syntax=python:sw=4:ts=4:expandtab

import sys, os
import operator
import getopt
import pyclbr
from pygraphviz import *

def get_members(obj):
    return ''

def get_methods(obj):
    methods = []
    for name, lineno in sorted(obj.methods.iteritems(), key=operator.itemgetter(1)):
        if name != "__path__":
            mod = '+'
            if name.startswith('__') and not name.endswith('__'):
                mod = '-'
            elif name.startswith('_') and name[1] != '_' and not name.endswith('__'):
                mod = '*'
            methods.append(mod + ' ' + name + '()')

    return '\l'.join(methods) + '\l'

def main(args, out_name):
    dict = {}
    for mod in args:
        if os.path.exists(mod):
            path = [os.path.dirname(mod)]
            mod = os.path.basename(mod)
            if mod.lower().endswith(".py"):
                mod = mod[:-3]
        else:
            path = []
        dict.update(pyclbr.readmodule_ex(mod, path))

    G = AGraph(strict=False,directed=True)
    G.graph_attr['fontname'] = 'Bitstream Vera Sans'
    G.graph_attr['fontsize'] = '8'
    G.graph_attr['rankdir'] = 'BT'
    G.node_attr['fontname'] = 'Bitstream Vera Sans'
    G.node_attr['fontsize'] = '8'
    G.node_attr['shape'] = 'record'
    G.edge_attr['fontname'] = 'Bitstream Vera Sans'
    G.edge_attr['fontsize'] = '8'
    G.edge_attr['arrowhead'] = 'empty'

    for obj in dict.values():
        if isinstance(obj, pyclbr.Class):
            G.add_node(obj.name)
            n = G.get_node(obj.name)
            n.attr['label'] = '{%s|%s|%s}' % (obj.name, get_members(obj), get_methods(obj))

            for sclass in obj.super:
                if isinstance(sclass, pyclbr.Class):
                    G.add_edge(obj.name, sclass.name)

    G.layout('dot')
    G.draw(out_name)
if __name__ == "__main__":
    optlist, args = getopt.getopt(sys.argv[1:], 'ho:')
    optlist = dict(optlist)

    if '-h' in optlist or '-o' not in optlist:
        print 'syntax: %s [-h] [-o path] files...' % (sys.argv[0])
        print '   -h   print this...'
        print '   -o   specific output filename'
        sys.exit(-1)

    main(args, optlist['-o'])
