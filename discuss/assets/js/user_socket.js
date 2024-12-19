import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})
socket.connect()

const createSocket = (topicId) => {
  let channel = socket.channel(`comments:${topicId}`, {})

  channel.on("new_comment", resp => {
    renderNewComment(resp.comment)
  })

  channel.join()
    .receive("ok", resp => {
      console.log("Joined successfully", resp);
      renderComments(resp.comments)
      })
    .receive("error", resp => { console.log("Unable to join", resp) })
  

  document.querySelector('#comment__button').addEventListener('click', () =>{
    const content = document.querySelector('#comment__textarea').value;
    channel.push('add_comment',{content: content})
  })
}

function commentTemplate(comment){
  let email = 'Anonymous';
  if (comment.user) email = comment.user.email;
  return `
        <li class="collection-item">
          ${comment.content}
          <div class="secondary-content">
          ${email}
          </div>
        </li>
      `;
}

function renderComments(comments){
  const renderedComments = comments.map(commentTemplate);
  document.querySelector("#comments_list").innerHTML = renderedComments.join('');
}

function renderNewComment(comment){
  const renderedComment = commentTemplate(comment);
  document.querySelector('#comments_list').innerHTML += renderedComment;
}



window.createSocket = createSocket;
