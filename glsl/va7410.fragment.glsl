#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//whatever the fuck

vec2 center = vec2(0.5,0.5);
float speed = 0.035;
float invAr = resolution.y / resolution.x;
void main(void)
{
	float time2 = floor(time * 100.0);
	vec2 uv = gl_FragCoord.xy / resolution.xy;
		
	vec3 col = vec4(uv,0.5+0.5*sin(time2),1.0).xyz;
   
     vec3 texcol;
			
	float x = (center.x-uv.x) * sin(time) + 0.5;
	float y = (center.y-uv.y) *invAr;
		
	//float r = -sqrt(x*x + y*y); //uncoment this line to symmetric ripples
	float r = -(x*x + y*y);
	float z = 1.0 + 0.5*sin((r+time2*speed)/0.013);
	
	texcol.x = z;
	texcol.y = z;
	texcol.z = z;
	
	gl_FragColor = vec4(col*texcol,1.0);
	//gl_FragColor = vec4(texcol,1.0);
}

