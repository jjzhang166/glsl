// by Dennis Hjorth


#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec4 mouse;

void main(void)
{
    //the centre point for each blob
    vec2 move1;
    move1.x = cos(sin(1.0/3.0*1.0*3.141592654*time*0.1)+time*1.5)*1.5;
    move1.y = sin(sin(1.0/3.0*1.0*3.141592654*time*0.1)+time*1.5)*0.8;
    vec2 move2;
    move2.x = cos(sin(2.0/3.0*1.0*3.141592654*time*0.1)+time*1.5)*1.5;
    move2.y = sin(sin(2.0/3.0*1.0*3.141592654*time*0.1)+time*1.5)*0.8;
    vec2 move3;
    move3.x = cos(sin(3.0/3.0*1.0*3.141592654*time*0.1)+time*1.5)*1.5;
    move3.y = sin(sin(3.0/3.0*1.0*3.141592654*time*0.1)+time*1.5)*0.8;
    vec2 move4;
    move4.x = cos(sin(4.0/3.0*1.0*3.141592654*time*0.1)+time*1.25)*1.5;
    move4.y = sin(sin(4.0/3.0*1.0*3.141592654*time*0.1)+time*1.75)*0.8;
    vec2 move5;
    move5.x = cos(sin(5.0/3.0*1.0*3.141592654*time*0.1)+time*1.25)*1.5;
    move5.y = sin(sin(5.0/3.0*1.0*3.141592654*time*0.1)+time*1.75)*0.8;
    vec2 move6;
    move6.x = cos(sin(6.0/3.0*1.0*3.141592654*time*0.1)+time*1.25)*1.5;
    move6.y = sin(sin(6.0/3.0*1.0*3.141592654*time*0.1)+time*1.75)*0.8;
    
    //screen coordinates
    vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
    p.x *= resolution.x / resolution.y;
  
    //radius for each blob
    float r1 =(dot(p-move1,p-move1))*64.0;
    float r2 =(dot(p-move2,p-move2))*64.0;
    float r3 =(dot(p-move3,p-move3))*64.0;
    float r4 =(dot(p+move4,p+move4))*64.0;
    float r5 =(dot(p+move5,p+move5))*64.0;
    float r6 =(dot(p+move6,p+move6))*64.0;

    //sum the meatballs
    vec3 meta1 =(1.0/r1)*vec3(1.0,0.3,0.3);
    vec3 meta2 =(1.0/r2)*vec3(0.3,1.0,0.3);
    vec3 meta3 =(1.0/r3)*vec3(0.3,0.3,1.0);
    vec3 meta4 =(1.0/r4)*vec3(1.0,0.1,1.0);
    vec3 meta5 =(1.0/r5)*vec3(1.0,1.0,0.1);
    vec3 meta6 =(1.0/r6)*vec3(0.1,1.0,1.0);
    //alter the cut-off power

    float red     = pow(meta1.x+meta2.x+meta3.x+meta4.x+meta5.x+meta6.x,2.0);
    float green   = pow(meta1.y+meta2.y+meta3.y+meta4.y+meta5.y+meta6.y,2.0);
    float blue    = pow(meta1.z+meta2.z+meta3.z+meta4.z+meta5.z+meta6.z,2.0);
    red   = red   > 1.0 ? 1.0 : red;
    green = green > 1.0 ? 1.0 : green;
    blue  = blue  > 1.0 ? 1.0 : blue;

    //set the output color
    gl_FragColor = vec4(red,green,blue,1.0);
}