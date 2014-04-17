#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform sampler2D texture;
uniform vec2 mouse;
uniform float time;

void main() {

	vec2 uv = gl_FragCoord.xy / resolution.xy;
	float ratio = resolution.y/resolution.x;
	
	vec2 uv2 = 2.5*(uv - vec2(0.5,0.5)); //verschiebung + skalierung
	
	vec2 z = vec2(uv2.x, uv2.y*ratio);
	vec2 c = mouse - vec2(0.5,0.5);
	
	vec2 res = vec2(z.x*z.x-z.y*z.y, 2.*z.x*z.y) + c; // z -> z^2 + c
	res /= vec2(2.0+sin(time),2.0+cos(time));
	
	vec2 tar = res + vec2(0.5,0.5);
	tar.y /= ratio;
	
	//gl_FragColor = vec4(0,0,0,1);
	gl_FragColor = 0.3*vec4(.5+.5*cos(1.5*time),.5+.5*sin(0.6*time),.5+.5*sin(0.8*time),12); // Farbe ausserhalb vom Bildschirm
	
	if(0. < tar.x && tar.x < 1. && 0. < tar.y && tar.y < 1.){ //onscreen?
		gl_FragColor = texture2D( texture, tar ) + vec4(.05,.05,.08,1)*exp(-length(res));
	}
	gl_FragColor.a = 1.;
}