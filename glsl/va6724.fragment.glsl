#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;

vec3 plasma(in vec2 w)
{
        vec3 col;

   float x = gl_FragCoord.x * w.x;
   float y = gl_FragCoord.y * w.y;
   float mov0 = x+y+cos(sin(time)*2.);
   float mov1 = y / resolution.y / 0.1 + time;
   float mov2 = x / resolution.x / 0.1;
   float c1 = abs(sin(mov1+time)/2.+mov2/2.-mov1-mov2+time);
   float c2 = abs(sin(c1+sin(mov0/1000.+time)+sin(y/400.+time)+sin((x+y)/100.)*3.));
   float c3 = abs(sin(c2+cos(mov1+mov2+c2)+cos(mov2)+sin(x/100.)));

        col = vec3(c2,c2,c3);
        return col;
}

void main(void)
{

    vec2 p = -0.0 + 1.0 * gl_FragCoord.xy / resolution.xy;

        vec3 col;
        vec2 w;
        vec3 total;

    vec2 d = (vec2(1.0,1.0)-p)/0.1;

    for( int i=0; i<180; i++ )
    {
        vec3 res = plasma(w);
        res = smoothstep(0.9,1.0,res*res);
        total += res;
        w += vec2(0.1,0.1);
    }
    total /= 30.0;

        col = total;
	        col *= vec3(0.25, 0.55, 0.8);

        col = clamp(col*col,0.0,1.0);

    float r = 2.5/(1.0+dot(p,p));

        gl_FragColor = vec4(col*r,0.0);

}