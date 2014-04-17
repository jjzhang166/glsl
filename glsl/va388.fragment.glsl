#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

uniform sampler2D backbuffer;

// @josep_llodra

float r( vec2 co ) {
	return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453 + time);
}

void main( void ) {

	vec2 uv = gl_FragCoord.xy/resolution;

	float c = r(uv) / 16.0;
	gl_FragColor = vec4(c,c,c,1.0);

        // based on @Flexi23
	vec2 d = 1./resolution;
	float dx = texture2D(backbuffer, uv + vec2(-1.,0.)*d).x - texture2D(backbuffer, uv + vec2(1.,0.)*d).x ;
	float dy = texture2D(backbuffer, uv + vec2(0.,-1.)*d).x - texture2D(backbuffer, uv + vec2(0.,1.)*d).x ;
	d = -vec2(dx,dy)*resolution/2048.;
	gl_FragColor.x = pow(clamp(1.-0.85*length(uv - mouse + d),0.,1.),3.0);
	gl_FragColor.y = gl_FragColor.z*0.6 + gl_FragColor.x*0.4;

	gl_FragColor *=1.;
}