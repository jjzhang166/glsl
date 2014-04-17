#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float raymarch(vec3 currentRay)
{
	return cos(currentRay.x)+cos(currentRay.y)+cos(currentRay.z);
}

vec3 getNormal(vec3 currentRay)
{
 vec3 f=vec3(0.01,0,0);
 return normalize(vec3(raymarch(currentRay+f.xyy),raymarch(currentRay+f.yxy),raymarch(currentRay+f.yyx)));
}

void main( void ) {

       vec2 position = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy + mouse / 2.0;
	position.x *= resolution.x / resolution.y;

       vec4 color = vec4(1.0);

	float distance = 0.0;
	vec3 origin = vec3(0.1, 0.01,time);
	vec3 currentRay = origin;
	vec3 direction = normalize(vec3(position.x, position.y, 1.0));
	for(int i = 0; i < 40; i++)
	{
		distance = raymarch(currentRay);
		currentRay += distance * direction;
	}

	float rayLength = length(currentRay-origin);
	 vec4 fog = vec4(cos(time * 0.3) * rayLength * 0.03 + 0.05, cos(time * 0.2) * rayLength * 0.04 + 0.05, sin(time * 0.1) * rayLength * 0.04 + 0.05, rayLength*0.02);
	color = vec4(max(dot(getNormal(currentRay),vec3(.1,.1,.0)),.0));
	color += fog +((1.-min(currentRay.y+2.0,1.))*vec4(sin(time)*0.3,cos(time)*.6,0.9,0.9))*min(time*.5,1.);
       gl_FragColor = color;

}