#ifdef GL_ES
precision highp float;
#endif
#define SIZE 2.7
#define SPEED .17

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

const float pi = 3.14159;

// by @notlion, @alteredq // h4x by @sphinx
float getSpring(float r, vec2 pos, float power){
  return (texture2D(backbuffer, pos).r - r) * power;
}

vec4 springMass(vec2 pos){
 
  vec2 pixel = .1 / resolution;
  float aspect = resolution.x / resolution.y;

  vec4 texel_prev = texture2D(backbuffer, pos);
  
  float r_prev = texel_prev.r;
  float power = .75;

  float vel = texel_prev.a - 0.5;
  vel += getSpring(r_prev, pos + pixel * vec2(2, 3), 0.0022411859348636983 * power);
  vel += getSpring(r_prev, pos + pixel * vec2(1, 3), 0.004759786021770571 * power);
  vel += getSpring(r_prev, pos + pixel * vec2(0, 3), 0.005681818181818182 * power);
  vel += getSpring(r_prev, pos + pixel * vec2(-1, 3), 0.004759786021770571 * power);
  vel += getSpring(r_prev, pos + pixel * vec2(-2, 3), 0.0022411859348636983 * power);
  vel += getSpring(r_prev, pos + pixel * vec2(3, 2), 0.0022411859348636983 * power);
  vel += getSpring(r_prev, pos + pixel * vec2(2, 2), 0.0066566640639421 * power);
  vel += getSpring(r_prev, pos + pixel * vec2(1, 2), 0.010022341036933013 * power);
  vel += getSpring(r_prev, pos + pixel * vec2(0, 2), 0.011363636363636364 * power);
  vel += getSpring(r_prev, pos + pixel * vec2(-1, 2), 0.010022341036933013 * power);
  vel += getSpring(r_prev, pos + pixel * vec2(-2, 2), 0.0066566640639421 * power);
  vel += getSpring(r_prev, pos + pixel * vec2(-3, 2), 0.0022411859348636983 * power);
  vel += getSpring(r_prev, pos + pixel * vec2(3, 1), 0.004759786021770571 * power);
  vel += getSpring(r_prev, pos + pixel * vec2(2, 1), 0.010022341036933013 * power);
  vel += getSpring(r_prev, pos + pixel * vec2(1, 1), 0.014691968395607415 * power);
  vel += getSpring(r_prev, pos + pixel * vec2(0, 1), 0.017045454545454544 * power);
  vel += getSpring(r_prev, pos + pixel * vec2(-1, 1), 0.014691968395607415 * power);
  vel += getSpring(r_prev, pos + pixel * vec2(-2, 1), 0.010022341036933013 * power);
  vel += getSpring(r_prev, pos + pixel * vec2(-3, 1), 0.004759786021770571 * power);
  vel += getSpring(r_prev, pos + pixel * vec2(3, 0), 0.005681818181818182 * power);
  vel += getSpring(r_prev, pos + pixel * vec2(2, 0), 0.011363636363636364 * power);
  vel += getSpring(r_prev, pos + pixel * vec2(1, 0), 0.017045454545454544 * power);
  vel += getSpring(r_prev, pos + pixel * vec2(-1, 0), 0.017045454545454544 * power);
  vel += getSpring(r_prev, pos + pixel * vec2(-2, 0), 0.011363636363636364 * power);
  vel += getSpring(r_prev, pos + pixel * vec2(-3, 0), 0.005681818181818182 * power);
  vel += getSpring(r_prev, pos + pixel * vec2(3, -1), 0.004759786021770571 * power);
  vel += getSpring(r_prev, pos + pixel * vec2(2, -1), 0.010022341036933013 * power);
  vel += getSpring(r_prev, pos + pixel * vec2(1, -1), 0.014691968395607415 * power);
  vel += getSpring(r_prev, pos + pixel * vec2(0, -1), 0.017045454545454544 * power);
  vel += getSpring(r_prev, pos + pixel * vec2(-1, -1), 0.014691968395607415 * power);
  vel += getSpring(r_prev, pos + pixel * vec2(-2, -1), 0.010022341036933013 * power);
  vel += getSpring(r_prev, pos + pixel * vec2(-3, -1), 0.004759786021770571 * power);
  vel += getSpring(r_prev, pos + pixel * vec2(3, -2), 0.0022411859348636983 * power);
  vel += getSpring(r_prev, pos + pixel * vec2(2, -2), 0.0066566640639421 * power);
  vel += getSpring(r_prev, pos + pixel * vec2(1, -2), 0.010022341036933013 * power);
  vel += getSpring(r_prev, pos + pixel * vec2(0, -2), 0.011363636363636364 * power);
  vel += getSpring(r_prev, pos + pixel * vec2(-1, -2), 0.010022341036933013 * power);
  vel += getSpring(r_prev, pos + pixel * vec2(-2, -2), 0.0066566640639421 * power);
  vel += getSpring(r_prev, pos + pixel * vec2(-3, -2), 0.0022411859348636983 * power);
  vel += getSpring(r_prev, pos + pixel * vec2(2, -3), 0.0022411859348636983 * power);
  vel += getSpring(r_prev, pos + pixel * vec2(1, -3), 0.004759786021770571 * power);
  vel += getSpring(r_prev, pos + pixel * vec2(0, -3), 0.005681818181818182 * power);
  vel += getSpring(r_prev, pos + pixel * vec2(-1, -3), 0.004759786021770571 * power);
  vel += getSpring(r_prev, pos + pixel * vec2(-2, -3), 0.0022411859348636983 * power);

  vel += (.25 - r_prev) * .25 * power; 

  vel += max(0., .1 * (abs(sin(time*2.)*.25)+.75 - (length((pos - mouse) * vec2(aspect, 1.)) * 15.)));

  return vec4(texel_prev.rgb + vel, vel * .98 + .5);

}

vec3 rotate(vec3 v,vec2 r) 
{
	mat3 rxmat = mat3(1,   0    ,    0    ,
			  0,cos(r.y),-sin(r.y),
			  0,sin(r.y), cos(r.y));
	mat3 rymat = mat3(cos(r.x), 0,-sin(r.x),
			     0    , 1,    0    ,
			  sin(r.x), 0,cos(r.x));
	
	
	return (v*rxmat)*rymat;
	
}

vec3 norm(vec3 v)
{
	//box made of 6 planes
	float tp = dot(v,vec3(0,-1,0))*SIZE;
	float bt = dot(v,vec3(0,1,0))*SIZE;
	float lf = dot(v,vec3(1,0,0))*SIZE;
	float rt = dot(v,vec3(-1,0,0))*SIZE;
	float fr = dot(v,vec3(0,0,1))*SIZE;
	float bk = dot(v,vec3(0,0,-1))*SIZE;
	
	return v/min(min(min(min(min(tp,bt),lf),rt),fr),bk);
}

float grid(vec3 v)
{
	float g;
	
	g = (length(v));
	g = (1.0-(g*g)*1.97)*1.38;
	return g*g-0.225;
}

void main( void ) {
	vec2 res = vec2(resolution.x/resolution.y,1.0);
	vec2 p = ( gl_FragCoord.xy / resolution.y ) -(res/2.0);
	
	vec2 m = mouse * 2. * pi;

	vec3 color = vec3(0.0);
	
	vec4 f = springMass((gl_FragCoord.xy / resolution.xy));
	
	vec3 pos = norm(rotate(vec3(p,f.a/2.),vec2(m)));
	
	
	float c = grid(pos-f.xyz*.1);
	
	
	color = vec3(c*(0.5+0.5*pos.x),c*(0.5+0.5*pos.y),c*(0.5+0.5*pos.z));
	
	vec3 final_c = color;
	
	gl_FragColor = vec4( .55 * (final_c.rgb + (f.xyz)), f.a);
}