#ifdef GL_ES
precision mediump float;
#endif
#define RADIANS 0.017453292519943295

uniform float time;
uniform vec2 resolution;

const int zoom = 50;
const float brightness = 0.95;
float fScale = 1.25;

float cosRange(float degrees, float range, float minimum) {
	return (((1.0 + cos(degrees * RADIANS)) * 0.5) * range) + minimum;
}

void main(void)
{
	
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	vec2 p=(2.0*gl_FragCoord.xy-resolution.xy)/max(resolution.x,resolution.y);
	float ct = cosRange(time*5.0, 3.0, 1.1);
	float scale = 0.5;
	float xBoost = cosRange(time*0.1, 5.0, 5.0);
	float yBoost = cosRange(time*0.1, 10.0, 5.0);
	
	fScale = cosRange(time * 0.5, 0.75, 0.75);
	
	for(int i=1;i<zoom;i++) {
		float _i = float(i);
		vec2 newp=p;
		newp.x+=scale/_i*sin(_i*p.x+time*0.25/10.0)*fScale+xBoost;		
		newp.y+=scale/_i*sin(_i*p.y+time*0.25/10.0)*fScale+yBoost;
		p=newp;
	}
	
	vec3 col=vec3(0.5*sin(3.0*p.x)+0.5,0.5*sin(3.0*p.y)+0.5,sin(p.x+p.y));
	gl_FragColor=vec4(col * brightness, 1.0);
	
}