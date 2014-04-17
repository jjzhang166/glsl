// by @notlion, @alteredq

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

vec2 mip(vec2 uv, float modulus){
    return vec2(uv.x - mod(uv.x, modulus/resolution.x), uv.y - mod(uv.y, modulus/resolution.y));
}

float getSpring(float r, vec2 pos, float power){
  return (texture2D(backbuffer, pos).r - r) * power;
}

void main(){
 
  float phase = 1./(mouse.x * 1000.)/.750;
	
	
  vec2 pos = gl_FragCoord.xy / resolution;
  vec4 texel_prev0 = cos(texture2D(backbuffer, pos));
  
  vec2 b0 = mip(pos, texel_prev0.r * 3.);
  vec2 b1 = mip(pos + b0, texel_prev0.g * 7.);
  vec2 b2 = mip(pos + b1, texel_prev0.b * 15.);
  vec2 b3 = mip(pos + b2, texel_prev0.a * 31.);
	
  vec2 rpos =  vec2(rand(b0), rand(b1)) + vec2(rand(b2), rand(b3));
  rpos = rpos * .5 - .5;
	
  vec2 pixel = max(vec2(.25), rpos / rpos) / resolution;
  float aspect = resolution.x / resolution.y;

  vec4 texel_prev = texture2D(backbuffer, pos + rpos * phase * max(1., texel_prev0.r));
  
  float r_prev = texel_prev.r;
  float power = .76;

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

  vel += (.25 - r_prev) * .00825 * power - vel * .005; 
  vel += max(0., .2 * (1. - (length((pos - (vec2(cos(132.*time), sin(132.*time))*.003+vec2(.8, .8))) * vec2(aspect, 1.)) * 15.)));
  vec4 result = vec4(texel_prev.rgb + vel, vel * .98 + .5);

  gl_FragColor = result;
}//sphinx