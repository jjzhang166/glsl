#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;
uniform sampler2D texture;

const float PI = 3.1415;

void main( void ) {
	float hx = 1./resolution.x;
	float hy = 1./resolution.y;
	float x = surfacePosition.x;
	float y = surfacePosition.y;
	float tau = .01*min(hx,hy)*min(hx,hy);
	if (time<2.) {
		gl_FragColor = vec4( sin(10.*PI*x), cos(10.*PI*y),  sin(10.*PI*y), 1.0 );
	} else {
		/*gl_FragColor = (1.-(2./hx+2./hy)*tau)*texture2D(texture,vec2(x,y));
		gl_FragColor += tau*texture2D(texture,vec2(x+hx,y))/hx;
		gl_FragColor += tau*texture2D(texture,vec2(x-hx,y))/hx;
		gl_FragColor += tau*texture2D(texture,vec2(x,y+hy))/hy;
		gl_FragColor += tau*texture2D(texture,vec2(x,y-hy))/hy;*/
		gl_FragColor = texture2D(texture,vec2(x*hx,y*hy));
	}
}