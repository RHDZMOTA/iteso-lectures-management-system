#!/usr/bin/env bash

function random-uuid() {
  python3 -c "import uuid; print(str(uuid.uuid4()))"
}

function repository-operations() {
  # Either clone repository or pull latest changes.
  local full_name="${1}"
  local target_path="${CREDIT_SCORING_STUDENT_INFO_PATH}/${full_name}"
  local repourl="git@github.com:${full_name}.git"
  if [ -d "${target_path}" ]; then
    echo "Repository ${full_name} exists; git fetch --all"
    git -C "${target_path}" fetch --all
    git -C "${target_path}" checkout master
    git -C "${target_path}" pull origin master
  else
    echo "Repository ${full_name} does not exists; git clone ..."
    git submodule add "${repourl}" "${target_path}"
  fi
}

function repo-forks() {
  # Get all forks for a given repository.
  local target_repo="${1}"
  while read -r full_name; do
    repository-operations "${full_name}"
  done < <(curl "https://api.github.com/repos/rhdzmota/${target_repo}/forks" | jq -r '.[].full_name')
}

function create-config() {
  # Create the configuration file for a given class.
  local tag="${1}"
  cat > ".env.${tag}" << EOF
CREDIT_SCORING_STUDENT_INFO_PATH=${tag}
CREDIT_SCORING_REPO_MAIN=$(random-uuid)
CREDIT_SCORING_REPO_EXAM_1=$(random-uuid)
CREDIT_SCORING_REPO_EXAM_2=$(random-uuid)
CREDIT_SCORING_REPO_EXAM_3=$(random-uuid)
EOF
}

function exam-opts() {
  case "${1}" in
    --first )
      echo "Getting the solutions for the first exam."
      repo-forks "${CREDIT_SCORING_REPO_EXAM_1}"
      ;;
    --second )
      echo "Getting the solutions for the second exam."
      repo-forks "${CREDIT_SCORING_REPO_EXAM_2}"
      ;;
    --third )
      echo "Getting the solutions for the third exam."
      repo-forks "${CREDIT_SCORING_REPO_EXAM_3}"
      ;;
    *)
      echo "Invalid option; --first, --second, --third"
      ;;
  esac
  shift
}

function main() {
  mkdir -p "${CREDIT_SCORING_STUDENT_INFO_PATH}"
  case "${1}" in
    --main )
      echo "Getting in sync with the main repository."
      repo-forks "${CREDIT_SCORING_REPO_MAIN}"
      ;;
    --create-config )
      echo ""
      create-config "${2}"
      ;;
    --exam )
      exam-opts "${2}"
      ;;
    * )
      echo "Invalid option; --main, --exam"
      ;;
  esac
  shift
}

main "${@}"
