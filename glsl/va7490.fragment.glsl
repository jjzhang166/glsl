#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


vec2 center = vec2(0.5,0.5);
float speed = 0.035;
float invAr = resolution.y / resolution.x;
float metric = 0.6;
float dec = 15.;
void main(void)
{
	vec2 uv = gl_FragCoord.xy / resolution.xy;
		
	//vec3 col = vec4(uv,(0.5+0.5*sin(time))*0.,1.0).xyz;
	vec3 col = vec3(uv,(0.75+0.25*sin(time)));
   
     	vec3 texcol;
			
	float x = (center.x-uv.x);
	float y = (center.y-uv.y) *invAr;
		
	float r = -pow(abs(pow(x,metric)) + abs(pow(y,metric)),1./metric);
	float z = 1.0 + 0.5 * sin(floor((r + time*speed)*dec)/dec/0.013);
	
	gl_FragColor = vec4(1.-vec3(z,z,z)*col, 1.0);
}

