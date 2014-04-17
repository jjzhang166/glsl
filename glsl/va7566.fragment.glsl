#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


vec2 center = mouse * 3.0;
float speed = 0.1;
float invAr = resolution.y / resolution.x;
void main(void)
{
	vec2 uv = gl_FragCoord.xy / resolution.xy;
		
	vec3 col = vec4(uv,0.5+0.5*sin(time),1.0).xyz;
   
     	vec3 texcol;
			
	float x = (center.x-uv.x);
	float y = (center.y-uv.y) *invAr;
		
	//float r = -pow(abs(y) + abs(y),0.25);
	float r = -(x * x *x *x*x+ y * y);
	float z = 1.0 + 0.5 * sin((r +  time*speed)/0.013);
	
	texcol.x = z;
	texcol.y = z;
	texcol.z = z;
	
	gl_FragColor = vec4(col*sin(texcol),1.0);
}

