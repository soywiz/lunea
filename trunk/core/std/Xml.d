/*
 *  Lunea library (gl2d)
 *  Copyright (C) 2005  Carlos Ballesteros Velasco
 *
 *  This file is part of Lunea.
 *
 *  This library is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public
 *  License as published by the Free Software Foundation; either
 *  version 2.1 of the License, or (at your option) any later version.
 *
 *  This library is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public
 *  License along with this library; if not, write to the Free Software
 *  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 *
 *  $Id: Xml.d,v 1.5 2006/01/21 20:17:19 soywiz Exp $
 */

module lunea.std.Xml;

private import std.file, std.ctype, std.stdio, std.string;

class Xml {
	enum {
		XML_NODE,
		XML_TEXT,
		XML_CDATA
	}

	public int type;

	public  char[] text;
	public  char[] name;
	public  char[][char[]] attributes;
	public  Xml[] children;
	public  Xml[][char[]] childrenGroups;
	public  Xml parent;

	private char[] data;
	private int datai;

	public Xml[] xpath(char[] path) {
		Xml[] retval;
		path = std.string.strip(path);
		if (!path.length) goto xpathend;

		path = std.string.replace(path, "\\", "/");

		while (path[0] == '/') path = path[1..path.length];
		char[] rest;
		int pos = find(path, "/");

		if (pos != -1) {
			rest = path[pos..path.length];
			path = path[0..pos];
		}

		if (path.length) {
			if (rest.length) {
				if ((path in childrenGroups) !is null) {
					foreach (Xml son; childrenGroups[path]) {
						foreach (Xml fson; son.xpath(rest)) if (fson !is null) retval ~= fson;
					}
				}
			} else {
				if ((path in childrenGroups) !is null) {
					foreach (Xml son; childrenGroups[path]) if (son !is null) retval ~= son;
				}
			}
		}

		if (parent is null && !retval.length) return xpath(rest);

		xpathend:

		return retval;
	}

	private char read() {
		if (datai >= data.length) return '\0';
		return data[++datai];
	}

	private void unread() {
		datai--;
	}

	private bit tryread(char c) {
		if (read == c) return true;
		unread();
		return false;
	}

	private bit eof() {
		return (datai >= data.length);
	}

	private bit white(char c) {
		return (c == ' ' || c == '\t' || c == '\r' || c == '\n' || c == '\0');
	}

	private void trywhite() {
		while (!eof && white(read)) { }
		if (!eof) unread;
	}

	private void opAddAssign(Xml that) {
		if (!that || (!that.name.length && !that.text.length)) return;

		this.children ~= that;
		if (that.name && that.name.length) this.childrenGroups[that.name] ~= that;
		that.parent = this;

		return;
	}

	private void add(Xml[] xmls, Xml after) {
		int length = this.children.length;
		int incv   = xmls.length;

		this.children.length = length + incv;

		for (int n = 0; n < length; n++) {
			if (this.children[n] == after) {
				n++;
				this.children[n + incv..length] = this.children[n..n + incv];
				this.children[n..n + incv] = xmls[0..incv];
				return;
			}
		}

		this.children[length..this.children.length] = xmls[0..incv];

		if (after.name && after.name.length) {
			int length = this.childrenGroups[after.name].length;
			int incv   = xmls.length;

			this.childrenGroups[after.name].length = length + incv;

			for (int n = 0; n < length; n++) {
				if (this.childrenGroups[after.name][n] == after) {
					n++;
					this.childrenGroups[after.name][n + incv..length] = this.childrenGroups[after.name][n..n + incv];
					this.childrenGroups[after.name][n..n + incv] = xmls[0..incv];
					return;
				}
			}

			this.childrenGroups[after.name][length..this.childrenGroups[after.name].length] = xmls[0..incv];
		}

		foreach (Xml son; xmls) son.parent = this;
	}

	private void opSubAssign(Xml that) {
		int length = this.children.length;
		for (int n = 0; n < length; n++) {
			if (that !is this.children[n]) continue;
			for (n++; n < length; n++) this.children[n - 1] = this.children[n];
			this.children.length = length - 1;
		}

		if (that.name && that.name.length) {
			int length = this.childrenGroups[that.name].length;
			for (int n = 0; n < length; n++) {
				if (that !is this.childrenGroups[that.name][n]) continue;
				for (n++; n < length; n++) this.childrenGroups[that.name][n - 1] = this.childrenGroups[that.name][n];
				this.childrenGroups[that.name].length = length - 1;
			}
		}

		that.parent = null;
	}

	private void childrenClear(Xml current) {
		current.children.length = 0;
		foreach (char[] key; current.childrenGroups.keys) {
			current.childrenGroups.remove(key);
		}
	}

	private void parse() {
		char[] buffer;

		void parseContent(Xml current = null) {
			char c;
			buffer = "";
			while (!eof) {
				switch (c = read) {
					case '<':
						buffer = std.string.strip(buffer);
						if (buffer.length) {
							if (current !is null) current.children ~= new Xml(buffer, true);
							buffer = "";
						}

						switch (c = read) {
							case '/': { // Must check validity
								char c;
								char[] tagname;
								while (!eof && (c = read) != '>') {
									tagname ~= c;
								}
								tagname = std.string.strip(tagname);
								if (current is null) return;

								if (tagname != current.name) {
									Xml zcurrent = current.parent;

									if (zcurrent && tagname == zcurrent.name) {
									//if (zcurrent) {
										zcurrent.add(current.children, current);
										childrenClear(current);
										//current = zcurrent;
										break;
									}
								}
								return;
							}
							case '!': // Must check validity
								while (!eof && read != '>') { }
								continue;
							case '?': // Must check validity
								while (!eof && read != '>') { }
								continue;
							default:
								char[] tagname;
								char[][char[]] tagattributes;
								unread();
								tagname = "";
								char c;
								while (!eof) {
									c = read;
									if (c == '/' || c == '>' || white(c)) break;
									tagname ~= c;
								}

								bit empty = false;

								while (!eof) {
									if (c == '/') {
										empty = true;
										c = read;
										continue;
									}

									if (c == '>') {
										break;
									}

									trywhite();

									char[] atrname = void;
									char[] atrvalue = void;

									atrname = "";
									while (!eof) {
										c = read;
										if (c == '/' || c == '>' || white(c)) break;
										if (c == '=') {
											trywhite();
											atrvalue = "";
											if (tryread('"')) {
												while (!eof) {
													c = read;
													if (c == '"') break;
													atrvalue ~= c;
												}
											} else if (tryread('\'')) {
												while (!eof) {
													c = read;
													if (c == '\'') break;
													atrvalue ~= c;
												}
											} else {
												while (!eof) {
													c = read;
													if (white(c) || c == '/' || c == '>') break;
													atrvalue ~= c;
												}
											}
											break;
										}
										atrname ~= c;
									}

									if (atrname.length) tagattributes[std.string.tolower(std.string.strip(atrname))] = atrvalue;
								}

								if (!empty) {
									if (current !is null) {
										Xml son = new Xml(tagname, tagattributes);
										current += son;
										parseContent(son);
									} else {
										this.name = tagname;
										this.attributes = tagattributes;
										parseContent(this);
									}
								} else {
									Xml son = new Xml(tagname, tagattributes);
									current += son;
								}

								continue;
							break;
						}
					break;
					default:
						buffer ~= c;
					break;
				}
			}

			buffer = std.string.strip(buffer);
			if (buffer.length) {
				if (current !is null) current += new Xml(buffer);
				buffer = "";
			}
		}

		datai = 0;
		parseContent();
		buffer = "";
		data = "";
	}

	void dump() {
		writef("%s", this.toString(true, true));
	}

	char[] toString(bit base = true, bit show = false, int level = 0) {
		char[] prefix;
		if (show) prefix = std.string.repeat("\t", level);

		if (text && text.length) {
			if (show) {
				return prefix ~ text ~ "\n";
			} else {
				return prefix ~ text;
			}
		}

		char[] retval = "";

		if (base) {
			retval ~= prefix ~ "<" ~ this.name;

			foreach (char[] key, char[] value; this.attributes) {
				retval ~= " " ~ key ~ "=\"" ~ value ~ "\"";
			}

			if (!this.children.length) {
				retval ~= " />";
				if (show) retval ~= "\n";
				return retval;
			}

			retval ~= ">";
			if (show) retval ~= "\n";
		}

		foreach (Xml son; this.children) {
			retval ~= son.toString(true, show, level + 1);
		}

		if (base) {
			retval ~= prefix ~ "</" ~ this.name ~ ">";
			if (show) retval ~= "\n";
		}

		return retval;
	}

	this() {
	}

	this(char[] name, char[][char[]] attributes) {
		this.name = name;
		this.attributes = attributes;
		this.type = XML_NODE;
	}

	this(char[] data, bit textnode = false) {
		if (textnode) { this.text = data; this.type = XML_TEXT; return; }
		this.data = data;
		this.parse();
		this.type = XML_NODE;
	}

	static Xml fromFile(char[] file) {
		return new Xml(cast(char[])std.file.read(file));
	}

    char[] opIndex(char[] name) {
		name = std.string.tolower(std.string.strip(name));
		if ((name in attributes) is null) return "";
		return attributes[name];
	}

    char[] opIndexAssign(char[] value, char[] name) {
		name = std.string.tolower(std.string.strip(name));
		return attributes[name] = value;
	}

	bit hasAttribute(char[] name) {
		name = std.string.tolower(std.string.strip(name));
		return ((name in attributes) !is null);
	}

	char[] getAttributeFiltered(char[] name) {
		return std.string.tolower(std.string.strip(this[name]));
	}
}

/+
class StreamParser {
	protected char[] streamdata;
	protected int    streampos;
	protected int    streamlen;

	protected char streamsetdata(char[] data) {
		streamdata = data;
		streampos  = 0;
		streamlen  = data.length;
	}

	protected char read() {
		if (eof) return 0;
		return streamdata[streampos++];
	}

	protected char unread() {
		if (streampos <= 0) return 0;
		return streamdata[--streampos];
	}

	protected int tell() {
		return streampos;
	}

	protected void seek(int v) {
		if (v < 0 || v >= streamlen) return;
		streampos = v;
	}

	protected bit eof() {
		return (streampos >= streamlen);
	}

	protected bit parse(bit delegate() vparse) {
		int pos = tell;
		bit retval = vparse();
		if (!retval) seek(pos);
		return retval;
	}

	protected bit parseChar(char c) {
		if (!eof) return false;
		if (read != c) { unread(); return false; }
		return true;
	}

	protected bit parseChar(char[] cs) {
		if (!eof) return false;
		char c = read();
		for (int n = cs.length; n > 0; n--) if (cs[n] == c) return true;
		unread();
		return false;
	}

	protected bit parseNotChar(char[] cs) {
		if (!eof) return false;
		char c = read();
		for (int n = cs.length; n > 0; n--) if (cs[n] == c) { unread(); return false; }
		return true;
	}

	protected bit isWhite(char c) {
		return (c == ' ' || c == '\t' || c == '\n' || c == '\r');
	}

	protected bit isAlpha(char c) {
		return (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z');
	}

	protected bit isNum(char c) {
		return (c >= '0' && c <= '9');
	}

	protected bit isAlnum(char c) {
		return isAlpha(c) || isNum(c);
	}
}

class XmlCharset {
	static public bit S(char c) {
		return (c == ' ' || c == '\t' || c == '\n' || c == '\r');
	}

	static public bit Letter(char c) {
		return (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z');
	}

	static public bit Digit(char c) {
		return (c >= '0' && c <= '9');
	}

	static public bit NameChar(char c) {
		return Letter(c) || Digit(c) || '.' || '-' || '_' || ':';
	}

	static public bit NameCharFirst(char c) {
		return Letter(c) || '_' || ':';
	}
}

class XmlParser : StreamParser {
	// [1] document ::= prolog element Misc*
	private bit parseDocument() {
		//if (!parse(&parseProlog )) return false;
		//if (!parse(&parseElement)) return false;
		//parse(&parseMisc);
		return true;
	}

	// [2] Char ::= #x9 | #xA | #xD | [#x20-#xD7FF] | [#xE000-#xFFFD] | [#x10000-#x10FFFF]

	// [3] S ::= (#x20 | #x9 | #xD | #xA)+
	private bit parseS() {
		static char[] pattern = "\x20\x09\x0D\x0A";
		if (!parseChar(pattern)) return false;
		while (!eof && parseChar(pattern)) { }
		return true;
	}

	// [4] NameChar	::= Letter | Digit | '.' | '-' | '_' | ':' | CombiningChar | Extender
	private bit parseNameChar() {
		char c = read;

		if (isAlnum(c)) return true;
		if (c == '.' || c == '-' || c == '_' || c == ':') return true;

		unread;
		return false;
	}

	// [5] Name	::= (Letter | '_' | ':') (NameChar)*
	private bit parseName() {
		char c = read;

		if ((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || c == '_' || c == ':') {
			while (parse(&parseNameChar)) { }
			return true;
		}

		unread;
		return false;
	}

	// [6] Names ::= Name (#x20 Name)*
	private bit parseNames() {
		if (!parse(&parseName)) return false;

		while (true) {
			char c = read;
			if (!parseChar(' ')) break;
			if (!parse(&parseName)) break;
		}

		return true;
	}

	// [7] Nmtoken ::= (NameChar)+
	private bit parseNmtoken() {
		if (!parse(&parseNameChar)) return false;
		while (parse(&parseNameChar)) { }
		return true;
	}

	// [8] Nmtokens	::= Nmtoken (#x20 Nmtoken)*
	private int parseNmtokens() {
		if (!parse(&parseNmtoken)) return false;
		while (!eof) {
			char c = read;
			if (!parseChar(' ')) break;
			if (!parse(&parseNmtoken)) break;
		}
		return true;
	}

	// [9] EntityValue ::= '"' ([^%&"] | PEReference | Reference)* '"' | "'" ([^%&'] | PEReference | Reference)* "'"
	private bit parseEntityValue() {
		if (parse(&parseEntityValue1)) return true;
		if (parse(&parseEntityValue2)) return true;
		return false;
	}

	private bit parseEntityValue1() {
		if (!parseChar('"')) return false;
		while (!eof) { if (!parseNotChar("%&\"") && !parse(&parsePEReference) && !parse(&parseReference)) break; }
		if (!parseChar('"')) return false;
		return true;
	}

	private bit parseEntityValue2() {
		if (!parseChar('\'')) return false;
		while (!eof) { if (!parseNotChar("%&'") && !parse(&parsePEReference) && !parse(&parseReference)) break; }
		if (!parseChar('\'')) return false;
		return true;
	}

	//[10] AttValue	::= '"' ([^<&"] | Reference)* '"' |  "'" ([^<&'] | Reference)* "'"
	private bit parseAttValue() {
		if (parse(&parseAttValue1)) return true;
		if (parse(&parseAttValue2)) return true;
		return false;
	}

	private bit parseAttValue1() {
		if (!parseChar('"')) return false;
		while (!eof) { if (!parseNotChar("<&\"") && !parse(&parseReference)) break; }
		if (!parseChar('"')) return false;
		return true;
	}

	private bit parseAttValue2() {
		if (!parseChar('\'')) return false;
		while (!eof) { if (!parseNotChar("<&'") && !parse(&parseReference)) break; }
		if (!parseChar('\'')) return false;
		return true;
	}

	// [40] STag ::= '<' Name (S Attribute)* S? '>'
	private bit parseEntitySTag() {
		if (!parseChar('<')) return false;
		if (!parse(&parseName)) return false;
		while (true) if (!parse(&parseEntitySTag1)) break;
		parse(&parseS);
		if (!parseChar('>')) return false;
		return true;
	}

	private bit parseEntitySTag1() {
		if (!parse(&parseS)) return false;
		if (!parse(&parseAttribute)) return false;
		return true;
	}

	// [41] Attribute ::= Name Eq AttValue
	private bit parseAttribute() {
		if (!parse(&parseName)) return false;
		if (!parseChar('=')) return false;
		if (!parse(&parseAttValue)) return false;
		return true;
	}
}+/