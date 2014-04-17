#ifdef GL_ES
precision mediump float;
#endif
#define RADIANS 0.017453292519943295

uniform float time;
uniform vec2 resolution;

const int zoom = 50;
const float brightness = 0.975;
float fScale = 1.25;

//via http://stackoverflow.com/questions/15095909/from-rgb-to-hsv-in-opengl-glsl
vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

float cosRange(float degrees, float range, float minimum) {
	return (((1.0 + cos(degrees * RADIANS)) * 0.5) * range) + minimum;
}

void main(void)
{
	
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	vec2 p=(2.0*gl_FragCoord.xy-resolution.xy)/max(resolution.x,resolution.y);
	float ct = cosRange(time*5.0, 3.0, 1.1);
	float xBoost = cosRange(time*0.1, 5.0, 5.0);
	float yBoost = cosRange(time*0.1, 10.0, 5.0);
	
	fScale = cosRange(time * 0.5, 0.75, 0.75);
	
	for(int i=1;i<zoom;i++) {
		float _i = float(i);
		vec2 newp=p;
		newp.x+=0.25/_i*sin(_i*p.y+time*cos(ct)*0.3/40.0+0.03*_i)*fScale+xBoost;		
		newp.y+=0.40/_i*sin(_i*p.x+time*ct*0.3/80.0+0.03*float(i+15))*fScale+yBoost;
		p=newp;
	}
	
	vec3 col=vec3(0.5*sin(3.0*p.x)+0.5,0.5*sin(3.0*p.y)+0.5,sin(p.x+p.y)); // let's try HSV not RGB in this fork

	col.x *= cos(time);
	col.y = col.y  * (.35 ); // lower saturation
	col.z *= 1.3; // .x in HSV is V, see http://en.wikipedia.org/wiki/HSL_and_HSV
	
	gl_FragColor=vec4(hsv2rgb(col), 1.0); // finally convert to RGB as required by GLSL
	
}