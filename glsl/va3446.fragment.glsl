#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec4 mouse;


void main(void)
{
vec2 uv = gl_FragCoord.xy / resolution.xy;
uv.x -= 0.5;
uv.y -= 0.5;
    //the centre point for each blob
    vec2 move1;
    move1.x = cos(time)*02.6;
    move1.y = sin(time*1.5)*0.6;
    vec2 move2;
    move2.x = cos(time*2.0)*0.26;
    move2.y = sin(time*3.0)*0.6;
   
 vec2 move3;
    move3.x = sin(time)* cos(time*0.7)*0.8;
    move3.y = cos(time*0.5) * sin(time*2.7)*0.8;
    
 
    //screen coordinates
    vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
    p.x *= 2.0;
    //radius for each blob
    float r1 =(dot(p-move1,p-move1))*8.0;
    float r2 =(dot(p+move2,p+move2))*6.0;
    float r3 =(dot(p+move3,p+move3))*3.0;

    //sum the meatballs
float metaball =(0.4/r1+0.4/r2+0.4/r3);
    float col2 = mod(time + 3.0* atan( (uv.y), (uv.x)),0.45) ;
//float metaball =(0.2/colr+0.2/colb+0.2/colg);
    //alter the cut-off power

col2 = 0.07 / col2;

float colr=col2+r1*0.5;
float colg=col2+r2*0.5;
float colb=col2+r3*0.5;
colr = 0.1 / colr+metaball*0.1;
colb = 0.1/colb+metaball*0.1;
colg = 0.1/colg+metaball*0.1;
	
    colg = pow(colg,1.4)*5.0;
    colr = pow(colr,1.4)*5.0;
    colb = pow(colb,1.4)*5.0;

//set the output color
 vec3 col = vec3(colr,colg,colb);
    
    col = clamp(col*0.5+0.5*col*col*1.2,0.0,1.0);

    //col *= 0.5 + 0.5*16.0*uv.x*uv.y*(1.0-uv.x)*(1.0-uv.y);

    col *= vec3(0.8,1.0,0.7);

    col *= 0.9+0.1*sin(10.0*time+uv.y*500.0 *sin(uv.x+time));

    col *= 0.97+0.03*sin(110.0*time);

col *= 3.0;

    gl_FragColor = vec4(col.r,col.g,col.b,1.0);
}