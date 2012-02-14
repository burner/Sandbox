module rules;


public static immutable string r0 = "ast.production0(stack[-1], stack[-2], stack[-3]);";
public static immutable string r1 = "ast.production1(stack[-1], stack[-2]);";

public static immutable(int[][]) array = [[1,2,3,4],[5,6,7],[8,9,10,11]];

public static immutable(string[]) rules = [
"ast.production0(stack[-1], stack[-2], stack[-3]);",
"ast.production1(stack[-1], stack[-2]);"];

public static immutable string ruleChoice = "
			switch(idx) {
				case 0:
					mixin(rules.r0);
					break;
				case 1:
					mixin(rules.r1);
					break;
				default:
					assert(false, format(\"no choice %u present \", idx));
			}";
