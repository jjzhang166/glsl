// by @notlion, @alteredq
#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

//http://glsl.heroku.com/e#336.0
vec4 vonNeuMannCritters() {
	vec4 result = vec4(0.); // init black

	vec2 pixel = 1./resolution;
	vec2 uv = gl_FragCoord.xy*pixel;

	bool mousePixel = uv.x + pixel.x > mouse.x && uv.x < mouse.x && uv.y + pixel.y > mouse.y && uv.y < mouse.y;
	float seed = mousePixel ? 1. : 0.;

	vec2 borderSize = pixel*4.;
	bool borderMask = uv.x < borderSize.x || uv.x > 1.-borderSize.x || uv.y < borderSize.y || uv.y > 1.- borderSize.y ;
	
	float rnd1 = mod(fract(sin(dot(uv + 30.*time, vec2(14.9898,78.233))) * 43758.5453), 1.0);
	float rnd2 = mod(fract(sin(dot(uv+vec2(rnd1), vec2(14.9898,78.233))) * 43758.5453), 1.0);
	float rnd3 = mod(fract(sin(dot(uv+vec2(rnd2), vec2(14.9898,78.233))) * 43758.5453), 1.0);
	float rnd4 = mod(fract(sin(dot(uv+vec2(rnd3), vec2(14.9898,78.233))) * 43758.5453), 1.0);

	vec2 rnd = pixel*(vec2(rnd3, rnd4)-0.5)*(2.+cos(time*31.)*sin(time*63.)* 4.); // critter code copied from http://glsl.heroku.com/91/0
	// http://en.wikipedia.org/wiki/Von_Neumann_neighborhood

	vec4 c = texture2D(backbuffer, uv + rnd);
	vec4 n = texture2D(backbuffer, uv + rnd + vec2(0.,-1.)*pixel);
	vec4 s = texture2D(backbuffer, uv + rnd + vec2(0.,1.)*pixel);
	vec4 e = texture2D(backbuffer, uv + rnd + vec2(-1.,0.)*pixel);
	vec4 w = texture2D(backbuffer, uv + rnd + vec2(1.,0.)*pixel);

	vec4 maxvn = max(c,max(max(n,s),max(e,w))); // maximum in the von Neumann neighborhood

	result = max(vec4(seed), maxvn);
	result += (vec4(rnd4,rnd3,rnd2,rnd1)-0.5)*0.0205 - 0.017; // error diffusion
	result.xyz += 0.3126*(gl_FragColor.yzx-gl_FragColor.zxy); // http://en.wikipedia.org/wiki/Belousov-Zhabotinsky_reaction
	return result;
}


float getSpring(float r, vec2 pos, float power){
  return (texture2D(backbuffer, pos).r - r) * power ;
}

void main(){
  vec2 pos = gl_FragCoord.xy / resolution;
  vec2 pixel = 8. / resolution;
  float aspect = resolution.x / resolution.y;
  vec4 vnc = vonNeuMannCritters();//noobed em together

  vec4 texel_prev = texture2D(backbuffer, pos) * .011 + vnc;
  
  float r_prev = texel_prev.r;
  float power = .5;

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

  vel += (.25 - r_prev) * .025 * power; 

  vel += max(0., .1 * (1. - (length((pos - mouse) * vec2(aspect, 1.)) * 24.)));

  gl_FragColor = vec4(texel_prev.rgb + vel, vel * .998 + .5);
  gl_FragColor *= vec4( 1.1, 0.975, 0.875, .99 );
}//sphinx