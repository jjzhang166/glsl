precision mediump float;
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
// teeny learning sketch from @danbri
// what makes it flicker?
void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;
        vec3 rgb = vec3(0.4,1.0,0.0);
        rgb.r = sin ( position.x * 4.) ;
        rgb.g = cos ( position.y * 2.) ;
        rgb.b = sin ( time * 2.) - position.x;
        if ( (sin(time / 4.) - position.x > 0.08) && (sin(time/4.) - position.x < 0.1 )) { rgb.rgb=vec3(.4,1.0,.0); }
        if ( (sin(time /4.) - position.x > 0.082) && (sin(time/4.) - position.x < 0.093 )) { rgb.rgb=vec3(.0,.0,.0); }
        if ( (sin(time /4.) - position.x > 0.084) && (sin(time/4.) - position.x < 0.096 )) { rgb.rgb=vec3(.2,.2,.2); }
        gl_FragColor = vec4( rgb, 1.0 );
}