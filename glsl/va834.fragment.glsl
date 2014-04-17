#ifdef GL_ES
precision highp float;
#endif
//fork_anony_gt
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

uniform sampler2D backbuffer;

float orbitDistance = .0005;
float waveLength = 75.000;

void main( void ) {
	vec2 uv = gl_FragCoord.xy/resolution;
  
	vec2 p1 = (vec2(sin(time), sin(time))*orbitDistance)-.5;
	vec2 p2 = (vec2(sin(time), sin(time))*orbitDistance)+.01*sin(time*2.5)+5.;

	float d1 = -length(uv +p1);
	float d2 = -length(uv -p2);
  
  	float wave1 = sin(d1*waveLength+(time*2.))*10. + 0.5 * (((d1 - cos(time*.5)-4.) * 1.) + 0.5);
	float wave2 = -cos(d2*waveLength+(time*1.))*2. + 0.5 * (((d1 - sin(time*.5)-2.) * 1.) + 0.5);
  
	float c = d1 > 0.99 || d2 > 0.995 ? 1. : 0.;
  
	//c + wave1*wave2*.03;
  
	gl_FragColor = vec4(c + wave1*wave2*.02,c,c,1.);

	vec2 d = 2./resolution;
	float dx = texture2D(backbuffer, uv + vec2(-1.,0.)*d).x - texture2D(backbuffer, uv + vec2(1.,0.)*d).x ;
	float dy = texture2D(backbuffer, uv + vec2(0.,-1.)*d).x - texture2D(backbuffer, uv + vec2(0.,1.)*d).x ;
	d = vec2(dx,dy)*resolution/resolution.x;
	gl_FragColor.z = pow(clamp(1.-.75*length(uv  - mouse + d),0.,1.),4.0);
	gl_FragColor.y = gl_FragColor.z*0.5 + gl_FragColor.x*.1;

	gl_FragColor *=2.1;

}