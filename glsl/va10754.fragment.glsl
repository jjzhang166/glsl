#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

struct TRI
{
  vec2 A;
  vec2 B;
  vec2 C;

  vec3 Ac;
  vec3 Bc;
  vec3 Cc;
};

struct VERTEX
{
  vec2 pos;
  vec3 color;
};
	
vec2 cheapNormalize(vec2 v)
{
  vec2 sqr = v * v;
  float sqrLen = sqr.x + sqr.y;
  return v / sqrLen;
}

float remap(float num, float in_min, float in_max, float out_min, float out_max)
{
  float zeroToOne = (num - in_min) / (in_max - in_min);
  return zeroToOne * (out_max - out_min) + out_min;
}

bool insideTriangle(TRI t, vec2 p, out VERTEX v)
{
	float fudge = 100000000.0;
	
	TRI invT;
	vec2 pToA = p - t.A;
	vec2 pToB = p - t.B;
	vec2 pToC = p - t.C;
	float pToALen = length(pToA);
	float pToBLen = length(pToB);
	float pToCLen = length(pToC);
	float i_pToALen = 1.0 / pToALen;
	float i_pToBLen = 1.0 / pToBLen;
	float i_pToCLen = 1.0 / pToCLen;
	float totalLen = i_pToALen + i_pToBLen + i_pToCLen;

	v.pos = p;
	v.color = (1.0/pToALen)*t.Ac + (1.0/pToBLen)*t.Bc + (1.0/pToCLen)*t.Cc;
	v.color /= totalLen;
	
	invT.A = (p - t.A)/pToALen * fudge;
	invT.B = (p - t.B)/pToBLen * fudge;
  	invT.C = (p - t.C)/pToCLen * fudge;
	
	float dotAccum = 0.0;
	dotAccum += dot(invT.A, invT.B);
	dotAccum += dot(invT.B, invT.C);
	dotAccum += dot(invT.C, invT.A);
	
	if( dotAccum < -(fudge * fudge) )
	  return true;
	
	return false;
}
	
	
void main( void )
{
	vec2 ratio = vec2(resolution.x / resolution.y, 1.0);
	vec2 uv = ( gl_FragCoord.xy / resolution.xy );
	vec2 position = uv * ratio;
	vec2 shiftNDC = position - (ratio/2.0);

	TRI t;
	t.A = vec2(1.25, 0.75);
	//t.A = mouse * ratio;
	t.B = vec2(0.75, 0.25);
	t.C = vec2(1.5, 0.25);
	t.Ac = vec3(1.0, 0.0, 0.0);
	t.Bc = vec3(0.0, 1.0, 0.0);
	t.Cc = vec3(0.0, 0.0, 1.0);
	
	VERTEX v;
	bool inside = insideTriangle(t, position, v);
	float clip = float(inside);


	// gl_FragColor = vec4( remap(dotAccum, -2.0, 2.0, 0.0, 1.0) );
	gl_FragColor = vec4( v.color * clip, 1.0 );
	float interp = dot( position - t.A, position - t.B );
	//gl_FragColor = vec4( remap(interp, -1.0, 0.0, 0.0, 1.0) );
}
	
	