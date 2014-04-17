#ifdef GL_ES
precision mediump float;
#endif

// By JvB. 
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float bump(vec2 p)
{
  //float d = sin(p.x+time)*1.2 + cos(p.y*1.2+time*1.1)*1.5 + sin(p.x*p.y*1.1+time*12.2); 
  float d = sin(10.0*length(p))*p.x*p.y*cos(p.x*p.y+time)*1.0; 
  return d; 
}

vec3 getnormal(vec2 p)
{
  vec2 eps = vec2(0.1,0.0);
  float nx = bump(p + eps.xy);
  float ny = bump(p + eps.yx);
  return normalize(vec3(nx,ny,1.0)); 
}

void main( void ) {

	float aspect = resolution.x/resolution.y; 
	vec2 p = 2.0*( gl_FragCoord.xy / resolution.xy ) - 1.0 ;
	p.x *= aspect;
	
	float ang = sin(time+mouse.x);
	vec2 uv = (sin(time*1.1)*5.0+6.0)*vec2(cos(ang)*p.x-sin(ang)*p.y,sin(ang)*p.x+cos(ang)*p.y);
	//vec2 uv = p*10.0;  
	vec3 n = getnormal(uv);
	
	vec3 lightpos = vec3(2.0*(vec2(cos(time),sin(time))-0.5),1.0);
	vec3 lv = lightpos - vec3(uv,0.0); 
	vec3 l = normalize(lv);
	float d = dot(n,l)/length(lv); 
	vec3 r = reflect(normalize(vec3(uv,1.0)),n);
	float spec = clamp(pow(dot(r,l),64.0), 0.0, 1.0);
	vec3 color = vec3(d) + spec*vec3(1,1,1)*1.01;
	gl_FragColor = vec4(color, 1.0);
}