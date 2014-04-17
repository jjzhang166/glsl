#ifdef GL_ES
precision mediump float;
#endif

varying highp vec2 coordinate;
uniform sampler2D image;

void main( void ) {
   vec2 ij = coordinate;
   vec2        xy = floor(ij);
   vec2 normxy = ij - xy;
   vec2 st0 = ((2.0 - normxy) * normxy - 1.0) * normxy;
   vec2 st1 = (3.0 * normxy - 5.0) * normxy * normxy + 2.0;
   vec2 st2 = ((4.0 - 3.0 * normxy) * normxy + 1.0) * normxy;
   vec2 st3 = (normxy - 1.0) * normxy * normxy;

   vec4 row0 =
        st0.s * texture2D(image, xy + vec2(-1.0, -1.0)) +
        st1.s * texture2D(image, xy + vec2(0.0, -1.0)) +
        st2.s * texture2D(image, xy + vec2(1.0, -1.0)) +
        st3.s * texture2D(image, xy + vec2(2.0, -1.0));

   vec4 row1 =
        st0.s * texture2D(image, xy + vec2(-1.0, 0.0)) +
        st1.s * texture2D(image, xy + vec2(0.0, 0.0)) +
        st2.s * texture2D(image, xy + vec2(1.0, 0.0)) +
        st3.s * texture2D(image, xy + vec2(2.0, 0.0));

   vec4 row2 =
        st0.s * texture2D(image, xy + vec2(-1.0, 1.0)) +
        st1.s * texture2D(image, xy + vec2(0.0, 1.0)) +
        st2.s * texture2D(image, xy + vec2(1.0, 1.0)) +
        st3.s * texture2D(image, xy + vec2(2.0, 1.0));

   vec4 row3 =
        st0.s * texture2D(image, xy + vec2(-1.0, 2.0)) +
        st1.s * texture2D(image, xy + vec2(0.0, 2.0)) +
        st2.s * texture2D(image, xy + vec2(1.0, 2.0)) +
        st3.s * texture2D(image, xy + vec2(2.0, 2.0));

   gl_FragColor = 0.25 * ((st0.t * row0) + (st1.t * row1) + (st2.t * row2) + (st3.t * row3));
}