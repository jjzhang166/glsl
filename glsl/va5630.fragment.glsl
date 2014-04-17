#ifdef GL_ES
precision mediump float;
#endif

// Posted by Trisomie21

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

float hash(float n) { return fract(sin(n)*1e5); }

float noise(vec3 p) {
	p += .5;
	const vec3 d = vec3(1.,30.,30.*30.);
	vec3 f = fract(p), p0 = (p-f)*d, p1 = p0 + d;
	return mix(mix(mix(hash(p0.x+p0.y+p0.z), hash(p1.x+p0.y+p0.z),f.x),
		       mix(hash(p0.x+p1.y+p0.z), hash(p1.x+p1.y+p0.z),f.x), f.y),
		   mix(mix(hash(p0.x+p0.y+p1.z), hash(p1.x+p0.y+p1.z),f.x),
		       mix(hash(p0.x+p1.y+p1.z), hash(p1.x+p1.y+p1.z),f.x), f.y), f.z);
}
float cloud(vec3 p) {
	float f = 0.0;
	f += .5000*noise(p*1.);
	f += .2500*noise(p*2.);
	f += .1250*noise(p*4.);
	f += .0625*noise(p*8.);
	return f;
}

void main( void ) {

	vec3 p = vec3(gl_FragCoord.xy / resolution.xy, fract(time*.01));

	float f = cloud(p*20.);
	
	gl_FragColor = vec4( vec3(f), 1.0 );
#if 1
	{
	vec2 uv = gl_FragCoord.xy / resolution.xy;		
	vec2 d = 4./resolution;
	float dx = texture2D(backbuffer, uv + vec2(-1.,0.)*d).x - texture2D(backbuffer, uv + vec2(1.,0.)*d).x ;
	float dy = texture2D(backbuffer, uv + vec2(0.,-1.)*d).x - texture2D(backbuffer, uv + vec2(0.,1.)*d).x ;
	d = vec2(dx,dy)*resolution/100.;
	gl_FragColor.y = pow(clamp(1.-1.5*length(uv  - vec2(.4,.6) + d*2.0),0.,1.),4.0);
	gl_FragColor.z = gl_FragColor.y*0.5 + gl_FragColor.x*0.4;
	}
#endif	
}