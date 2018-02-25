
class CodeGen:
    '''
    buffer to append code in various sections of a file
    in any order
    '''

    _one_indent_level = '    '

    def __init__(self):
        self._sections = []
        self._indents = []
        self._sect = 0
        self._sections.append([])
        self._indents.append(0)

    @property
    def section(self):
        return self._sect

    @section.setter
    def section(self, section):
        '''
        Set the section of the file where to append code.
        Allows to make different sections in the file to append
        to in any order
        '''
        while len(self._sections) <= section:
            self._sections.append([])
            self._indents.append(0)
        self._sect = section


    def indentBlock(self):
        class Indenter(object):
            def __init__(self, sf):
                self.sf = sf
            def __enter__(self):
                self.sf.indent()
            def __exit__(self, type, value, traceback):
                self.sf.unindent()
        return Indenter(self)

    def indent(self):
        '''
        adds one level of indentation to the current section
        '''
        self._indents[self._sect] += 1

    def unindent(self):
        '''
        removes one level of indentation to the current section
        '''
        assert self._indents[self._sect] > 0, "negative indent"
        self._indents[self._sect] -= 1

    def __call__(self, fmt="", *args):
        '''
        Append a line to the file at in its current section and
        indentation of the current section
        '''
        indent = CodeGen._one_indent_level * self._indents[self._sect]
        self._sections[self._sect].append(indent + (fmt % args))


    def writeOut(self, outFile, sect=-1):
        if sect < 0:
            for sect in self._sections:
                for line in sect:
                    print(line.rstrip(), file=outFile)
        else:
            for line in self._sections[sect]:
                print(line.rstrip(), file=outFile)
