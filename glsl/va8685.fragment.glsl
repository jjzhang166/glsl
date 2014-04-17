
// Birdie demo workshop example

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
// {
// }

float scene(in vec3 pos)
{
	
	float r = 0.5; 
	pos.x *= 0.2; 
	pos.x = mod(pos.x+1.0, 2.0) - 1.0;
	pos.y += sin(pos.x*6.0+time)*1.5;
	pos.y += -abs(sin(time*1.5)); 
	//pos.y *= 1.0+0.25*sin(20.0*time*1.5)*exp(-mod(time*1.5, 3.1415926535897932384486));
	//pos.x *= 1.0+0.25*cos(20.0*time*0.5)*exp(-mod(time*1.5, 3.1415926535897932384486));
	
	return length(pos) - r;
}	

vec3 get_normal(in vec3 p)
{
	
	vec3 eps = vec3(0.001, 0.0, 0.0); 
	
	float nx = scene(p + eps.xyy) - scene(p - eps.xyy);
	float ny = scene(p + eps.yxy) - scene(p - eps.yxy);
	float nz = scene(p + eps.yyx) - scene(p - eps.yyx);
	return normalize(vec3(nx,ny,nz)); 
}
	
void main( void ) {

	vec2 p = 2.0 * ( gl_FragCoord.xy / resolution.xy ) - 1.0;
	p.x *= resolution.x/resolution.y; 
	vec3 color = vec3(0); 
	
	
	vec3 ro= vec3(0,0,2.0); 
	vec3 rd = normalize(vec3(p.x,p.y,-1.0)); 
	
	vec3 pos = ro; 
	float dist = 0.0; 
	float d = 0.0;
	for (int i = 0; i < 96; i++) {
			
		d = scene(pos); 
		pos += rd*d;
		dist += d;
	}
	
	if (dist < 10.0) 
	 {
		color = vec3(1,1,1);
		vec3 n = get_normal(pos); 
		vec3 l = normalize(vec3(1,1,1));
		vec3 r = reflect(pos, n); 
		float diff = clamp(dot(n, l), 0.0, 1.0); 
		float spec = pow(clamp(dot(r, normalize(vec3(10,10,10)-pos)),0.0,1.0),64.0); 
		
		color = vec3(1,1,1)*0.1 + vec3(1,0,0)*diff ; 
	}
	else 
	{
		color = vec3(0.1,0.1,0.2); 			
	}
	gl_FragColor = vec4(color, 1.0); 
}