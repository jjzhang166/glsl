#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;
uniform sampler2D tex;

vec4 checker(vec2 uv) {
  float checkSize = 100.0;
  float fmodResult = mod(floor(checkSize * uv.x) + floor(checkSize * uv.y),
                          2.0);
  if (fmodResult < 1.0) {
    return vec4(0, 1, 1, 1);  // turquiose
  } else {
    return vec4(1, 0, 1, 1);  // magenta
  }
}


void main(void)
{
    vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
    p.x *= resolution.x / resolution.y;

    vec2 uv;
   
    float a = atan(p.y,p.x);
    float r = sqrt(dot(p,p));

    uv.x = .15*time+.1/r;
    uv.y = .1*time + a/(3.1416);
		

    vec3 col =  checker(uv).xyz;

    gl_FragColor = vec4(col*r,10.0)*100.3;
}