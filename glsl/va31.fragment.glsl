// by @notlion, @alteredq

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

float getSpring(float r, vec2 pos, float power){
  return (texture2D(backbuffer, pos).r - r) * power;
}

void main(){
  vec2 pos = gl_FragCoord.xy / resolution;
  vec2 pixel = 8. / resolution;
  float aspect = resolution.x / resolution.y;

  vec4 texel_prev = texture2D(backbuffer, pos);
  
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

  vel += max(0., .1 * (1. - (length((pos - mouse) * vec2(aspect, 1.)) * 15.)));

  gl_FragColor = vec4(texel_prev.rgb + vel, vel * .98 + .5);
  gl_FragColor *= vec4( 1.0, 0.85, 0.0, 1.0 );

}