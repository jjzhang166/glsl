#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float textureRND2D(vec2 uv)
{
	vec2 f = fract(uv);
	f = f*f*(3.0-2.0*f);
	uv = floor(uv);
	vec4 r = vec4(uv.x+uv.y*1e3) + vec4(0., 1., 1e3, 1e3+1.);
	r = fract(sin(r*1e-3)*1e5);
	return mix(mix(r.x, r.y, f.x), mix(r.z, r.w, f.x), f.y);	
}

void main( void )
{
	vec2 p = gl_FragCoord.xy/resolution.xy;
	float c0 = step(textureRND2D(p*vec2(8.,.5)+vec2(100.+time*.2,0.))*.5, p.y-.1);
	float c1 = step(textureRND2D(p*vec2(80.,.5)+vec2(time*2.,time))*.02, p.y-.3);
	gl_FragColor = vec4(mix(vec3(.8,.6,.2)*p.y,mix(vec3(.7,.8,1.2)*p.y, vec3(p.y), c1), c0),1.0);
}