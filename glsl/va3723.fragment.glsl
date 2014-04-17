#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

float rand( const in vec2 v )
{
	float value = fract( sin(time + v.x * 1014.43572) * 31344.234 + sin(time + v.y * 3442.43572) * 543.234);
	
	return value;
}


vec3 GetColour(float x)
{	
	x = x * x;
	return vec3(x, x * x, x * x * x * x);
}

void main( void ) {

	vec2 vPos = ( gl_FragCoord.xy / resolution.xy );

	vec3 vPrev = texture2D(backbuffer, vPos).xyz;
	
	vec3 vNext = vPrev * 0.98 - (1.0 / 255.0);
	
	vec2 d = mouse - vPos;
	d.y *= resolution.y / resolution.x;
	float l = 1.0 - length(d);
	l = pow(l, 5.0);
	
	float fCurr = max(0.0, l + rand(gl_FragCoord.xy) * 0.01);
	fCurr = max(fCurr, 0.0);
	fCurr = min(fCurr, 1.0);
	
	vec3 vCurr = GetColour(fCurr);
	
	vNext = max(vNext, vCurr);
	
	gl_FragColor = vec4( vNext, 1.0 );
}