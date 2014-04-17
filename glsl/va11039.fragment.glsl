#ifdef GL_ES
precision highp float;
#endif
uniform float time;
uniform vec2 resolution;

const float Pi = 3.14159;
const int zoom = 40;
const float speed = 0.01;
float fScale = 1.25;

void main(void)
{
	
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	vec2 p=(2.0*gl_FragCoord.xy-resolution.xy)/max(resolution.x,resolution.y);
	
	float ct = time * speed;
	
	for(int i=1;i<zoom;i++) {
		vec2 newp=p;
		newp.x+=0.25/float(i)*cos(float(i)*p.y+time*cos(ct)*0.3/40.0+0.03*float(i))*fScale+10.0;		
		newp.y+=0.5/float(i)*cos(float(i)*p.x+time*ct*0.3/50.0+0.03*float(i+10))*fScale+15.0;
		p=newp;
	}
	
	vec3 col=vec3(sin(3.0*p.x),1,1);
	gl_FragColor=vec4(col, 1.0);
}