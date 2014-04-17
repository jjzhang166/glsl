// @rianflo
// work in progress
//
// call to action: can somebody make a kickass tree?
//

#ifdef GL_ES
precision lowp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

struct BranchParam
{
	vec2 root;
	vec2 dir;
	float height;
	float straightness;
	float thickness;
};
	
float rand(vec2 co)
{
    return fract(sin(dot(co.xy, vec2(13.4352,56.4321))) * 57346.1234);
}

vec2 bend(vec2 p, float b)
{
    float c = cos(b);
    float s = sin(b);
    mat2  m = mat2(c,-s,s,c);
    return m*p;
}

vec2 segment(vec2 p, vec2 a, vec2 b)
{
	vec2 pa = p - a;
	vec2 ba = b - a;
	float h = clamp( dot(pa,ba)/dot(ba,ba), 0.0, 1.0 );
	return vec2( length( pa - ba*h ), h );
}

vec2 rotate(vec2 v, float ang)
{
	mat2 m = mat2(cos(ang), sin(ang), -sin(ang), cos(ang));
	return m * v;
}

float smin(float a, float b)
{
    	float k = 0.025;
	float h = clamp( 0.5 + 0.5*(b-a)/k, 0.0, 1.0 );
	return mix( b, a, h ) - k*h*(1.0-h);
}

float sdBranch(vec2 p, BranchParam bp)
{
	vec2 top = bp.root + bp.dir * bp.height;
	vec2 seg = segment(p, top, bp.root);
	float th = smoothstep(0.0, bp.straightness, seg.y);
	float t = th*bp.height*bp.thickness;
	return seg.x - t;	
}

float sdBranchThickness(vec2 p, BranchParam bp)
{
	vec2 top = bp.root + bp.dir * bp.height;
	vec2 seg = segment(p, top, bp.root);
	float th = smoothstep(0.0, bp.straightness, seg.y);
	return th*bp.height*bp.thickness;	
}

void branchOff(inout BranchParam child, in BranchParam parent, in int seed)
{
	child.root = parent.root + mix(0.0, parent.height*0.5, rand(vec2(parent.height, seed))) * parent.dir;
	child.thickness = abs(sdBranchThickness(child.root, parent)) * 0.55;
	child.straightness = parent.straightness * 1.1;
	child.dir = rotate(parent.dir, rand(vec2(seed))-0.25);
	child.height = parent.height * 0.75;
}


const int MAX_BRANCHES = 4;
const int MAX_DEPTH = 4;

void main() 
{
	vec2 p = (-resolution.xy + 2.0 * gl_FragCoord.xy) / resolution.y;
	vec2 m = (mouse * 2.0 - 1.0) * vec2(resolution.x / resolution.y, 1.0);
	float height = ((m.y+1.0));

	BranchParam tree = BranchParam(vec2(0.0, -1.0), vec2(0.0, 1.0), height, 0.5, 0.04);
	float sd = sdBranch(p, tree);

	for (int i=0; i<MAX_BRANCHES; i++)
	{
		BranchParam last = tree;
		BranchParam current;
		for (int d=0; d<MAX_DEPTH; d++)
		{
			branchOff(current, last, i*d*999);
			sd = min(sd, sdBranch(p, current));
			last = current;
		}
	}
	
	vec3 color = (sd < 0.0005) ? vec3(1.0) : vec3(sd);
	gl_FragColor = vec4(color, 1.0);
}
