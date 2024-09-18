import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import 'overlay_manager.dart';

abstract class MathSelectionGestureDetectorBuilderDelegate {
  bool get forcePressEnabled;

  bool get selectionEnabled;
}

class MathSelectionGestureDetectorBuilder {
  MathSelectionGestureDetectorBuilder({
    required this.delegate,
  });
  final SelectionOverlayManagerMixin delegate;

  bool get shouldShowSelectionToolbar => _shouldShowSelectionToolbar;
  bool _shouldShowSelectionToolbar = true;

  @protected
  Offset? lastTapDownPosition;

  @protected
void onTapDown(TapDragDownDetails details) {
  lastTapDownPosition = details.globalPosition;
  final kind = details.kind;
  _shouldShowSelectionToolbar = kind == null ||
      kind == PointerDeviceKind.touch ||
      kind == PointerDeviceKind.stylus;
}


  @protected
  void onForcePressStart(ForcePressDetails details) {
    assert(delegate.forcePressEnabled);
    _shouldShowSelectionToolbar = true;
    if (delegate.selectionEnabled) {
      delegate.selectWordAt(
        offset: details.globalPosition,
        cause: SelectionChangedCause.forcePress,
      );
    }
  }

  @protected
  void onForcePressEnd(ForcePressDetails details) {
    assert(delegate.forcePressEnabled);
    delegate.selectWordAt(
      offset: details.globalPosition,
      cause: SelectionChangedCause.forcePress,
    );
    if (shouldShowSelectionToolbar) {
      delegate.showToolbar();
    }
  }

// @protected
// void onSingleTapUp(TapDragUpDetails details) {
//   if (delegate.selectionEnabled) {
//     delegate.selectPositionAt(
//         from: lastTapDownPosition!, cause: SelectionChangedCause.tap);
//   }
// }

  @protected
  void onSingleTapCancel() {
    /* Subclass should override this method if needed. */
  }

  @protected
  void onSingleLongTapStart(LongPressStartDetails details) {
    if (delegate.selectionEnabled) {
      delegate.selectPositionAt(
        from: details.globalPosition,
        cause: SelectionChangedCause.longPress,
      );
    }
  }

  @protected
  void onSingleLongTapMoveUpdate(LongPressMoveUpdateDetails details) {
    if (delegate.selectionEnabled) {
      delegate.selectPositionAt(
        from: details.globalPosition,
        cause: SelectionChangedCause.longPress,
      );
    }
  }

  @protected
  void onSingleLongTapEnd(LongPressEndDetails details) {
    if (shouldShowSelectionToolbar) {
      delegate.showToolbar();
    }
  }

  // @protected
  // void onDoubleTapDown(TapDownDetails details) {
  //   if (delegate.selectionEnabled) {
  //     delegate.selectWordAt(
  //         offset: details.globalPosition, cause: SelectionChangedCause.tap);
  //     if (shouldShowSelectionToolbar) delegate.showToolbar();
  //   }
  // }

  // @protected
  // void onDragSelectionStart(DragStartDetails details) {
  //   delegate.selectPositionAt(
  //     from: details.globalPosition,
  //     cause: SelectionChangedCause.drag,
  //   );
  // }

  @protected
  void onDragSelectionEnd(TapDragEndDetails details) {
    /* Subclass should override this method if needed. */
  }

  // @protected
  // void onDragSelectionUpdate(
  //   TapDragStartDetails startDetails, TapDragUpdateDetails updateDetails) {
  //   delegate.selectPositionAt(
  //     from: startDetails.globalPosition,
  //     to: updateDetails.globalPosition,
  //     cause: SelectionChangedCause.drag,
  //   );
  // }


  TextSelectionGestureDetector buildGestureDetector({
    Key? key,
    HitTestBehavior? behavior,
    required Widget child,
  }) =>
      TextSelectionGestureDetector(
        key: key,
        onTapDown: onTapDown,
        onForcePressStart:
            delegate.forcePressEnabled ? onForcePressStart : null,
        onForcePressEnd: delegate.forcePressEnabled ? onForcePressEnd : null,
        // onSingleTapUp: onSingleTapUp,
        onSingleTapCancel: onSingleTapCancel,
        onSingleLongTapStart: onSingleLongTapStart,
        onSingleLongTapMoveUpdate: onSingleLongTapMoveUpdate,
        // onSingleLongTapEnd: onSingleLongTapEnd,
        // onDoubleTapDown: onDoubleTapDown,
        // onDragSelectionStart: onDragSelectionStart,
        // onDragSelectionUpdate: onDragSelectionUpdate,
        // onDragSelectionEnd: onDragSelectionEnd,
        behavior: behavior,
        child: child,
      );
}
