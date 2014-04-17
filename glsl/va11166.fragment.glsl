#ifdef GL_ES
precision highp float;
#endif
uniform float time;
uniform vec2 resolution;

const float Pi = 3.14159;
const int zoom = 80;
const float speed = 0.5;
float fScale = 2.0;

void main(void)
{
	
	vec2 uv = gl_FragCoord.xy / resolution.xy;
	vec2 p=(2.0*gl_FragCoord.xy-resolution.xy)/max(resolution.x,resolution.y);
	
	float ct = time * speed;
	
	for(int i=1;i<zoom;i++) {
		vec2 newp=p;
		newp.x+=0.25/float(i)*cos(float(i)*p.y+time*cos(ct)*0.3/40.0+0.03*float(i))*fScale+0.0;		
		newp.y+=0.25/float(i)*cos(float(i)*p.x+time*ct*0.3/50.0+0.03*float(i+10))*fScale+0.0;
		p=newp;
	}
	//p = uv;
	
	vec3 col=vec3((10.0*sin(9.0*p.x)),10.0*sin(5.0*p.y),10.0*sin(p.x+p.y)*cos(p.x+p.y));
	gl_FragColor=vec4(col, 1.0);
}